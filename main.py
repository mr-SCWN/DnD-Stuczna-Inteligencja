import clips
from tkinter import *

def get_properties(name):
    return properties[name]

def get_current_id():
    eval_str = '(find-all-facts ((?f state-list)) TRUE)'
    curr_id = str(clips_env.eval(eval_str)[0]['current'])
    return curr_id

def get_curret_UIstate():
    curr_id = get_current_id()
    eval_str = '(find-all-facts ((?f UI-state)) ' + '(eq ?f:id ' + curr_id + '))'
    UIstate = clips_env.eval(eval_str)[0]
    return UIstate

def update_textes(start=False):
    UIstate = get_curret_UIstate()
    valid_answers = UIstate['valid-answers']
    answers_amount = min(len(valid_answers), 4)
    answer_button_amount = 0

    for id, text in enumerate(all_textes):
        if id + 1 <= answers_amount:
            text.set(get_properties(str(valid_answers[id])))
            if not start:
                all_buttons[id].grid(row=id + 1, column=answers_amount)
                answer_button_amount += 1
        else:
            text.set('')
            if not start:
                all_buttons[id].grid_remove()

    state = str(UIstate['state'])

    if state == 'initial':
        text_button_back.set('Start')
    elif state == 'final':
        text_button_back.set('Restart')
    else:
        text_button_back.set('Back')

    text_question.set(get_properties(UIstate['display']))

    if not start:
        if state == 'final':
            question.configure(font='Helvetica 18 bold', relief=GROOVE, padx=10, pady=10, fg='#e9736a', bd=3)
        else:
            question.configure(textvariable=text_question, padx=1, pady=7, bg='#F5F5DC', fg='#FFA500', font='Helvetica 12 bold', bd=1, relief=FLAT)

    if not start:
        question.grid(row=0, column=0, columnspan=answers_amount + 1)
        empty_space.grid(row=answers_amount + 2, column=0, columnspan=answers_amount + 1)
        empty_space.grid(row=answers_amount + 2, column=0, columnspan=answers_amount + 1)
        button_back.grid(row=answers_amount + 3, column=0, columnspan=answers_amount + 1)

def ans_button_command(id):
    curr_id = get_current_id()
    UIstate = get_curret_UIstate()
    valid_answers = UIstate['valid-answers']
    answer = valid_answers[id]
    clips_env._facts.assert_string('(next ' + curr_id + ' ' + answer + ')')
    clips_env._agenda.run()
    update_textes()

def back_button_command():
    UIstate = get_curret_UIstate()
    state = str(UIstate['state'])
    curr_id = get_current_id()

    if state == 'final':
        clips_env.reset()
        clips_env._agenda.run()
        update_textes()
        return

    if state == 'initial':
        clips_env._facts.assert_string('(next ' + curr_id + ')')
        clips_env._agenda.run()

    if state == 'middle':
        clips_env._facts.assert_string('(prev ' + curr_id + ')')
        clips_env._agenda.run()

    update_textes()

if __name__ == '__main__':
    root = Tk()
    root.geometry('720x400')
    root.config(bg='#F5F5DC')

    clips_env = clips.Environment()
    clips_env.load('logical.clp')
    clips_env.reset()
    clips_env._agenda.run()

    properties = {}

    text_button1 = StringVar()
    text_button2 = StringVar()
    text_button3 = StringVar()
    text_button4 = StringVar()
    text_button_back = StringVar()
    text_question = StringVar()

    all_textes = [text_button1, text_button2, text_button3, text_button4 ]

    file = open('asnwers.txt', 'r')
    data = file.readlines()

    for line in data:
        name, full_name = line.replace('\n', '').split('=')
        properties[name] = full_name

    file.close()
    update_textes(start=True)

    root.title('What Race Should I Play')

    question = Label(root, textvariable=text_question, pady=7, bg='#F5F5DC', fg='#FFA500', font='Helvetica 12 bold')
    empty_space = Label(root, text='', bg='#F5F5DC', height=2)

    button_ans1 = Button(root, textvariable=text_button1, width=90, padx=2, pady=2, command=lambda: ans_button_command(0), borderwidth=3, activebackground='#9ada7d', bg='#0099cc', fg='#0b0b0b', font='Helvetica 10 bold')
    button_ans2 = Button(root, textvariable=text_button2, width=90, padx=2, pady=2, command=lambda: ans_button_command(1), borderwidth=3, activebackground='#9ada7d', bg='#0099cc', fg='#0b0b0b', font='Helvetica 10 bold')
    button_ans3 = Button(root, textvariable=text_button3, width=90, padx=2, pady=2, command=lambda: ans_button_command(2), borderwidth=3, activebackground='#9ada7d', bg='#0099cc', fg='#0b0b0b', font='Helvetica 10 bold')
    button_ans4 = Button(root, textvariable=text_button4, width=90, padx=2, pady=2, command=lambda: ans_button_command(3), borderwidth=3, activebackground='#9ada7d', bg='#0099cc', fg='#0b0b0b', font='Helvetica 10 bold')

    #mb need to add more buttons

    button_back = Button(root, textvariable=text_button_back, width=90, padx=2, pady=2, command=lambda: back_button_command(), borderwidth=4, activebackground='#9ada7d', bg='#0099cc', fg='#0b0b0b', font='Helvetica 10 bold')

    all_buttons = [button_ans1, button_ans2, button_ans3, button_ans4 ]

    question.grid(row=0, column=0)
    empty_space.grid(row=1, column=0)
    empty_space.grid(row=2, column=0)
    button_back.grid(row=3, column=0, sticky='we')

    root.mainloop()
