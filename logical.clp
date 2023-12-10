;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))
   
(deftemplate state-list
   (slot current)
   (multislot sequence))
  
(deffacts startup
   (state-list))


;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""

  =>
  
  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))







;;;***************
;;;* QUERY RULES *
;;;***************

(defrule choose_start_question ""
    (logical (start))
    =>
    (assert (UI-state (display StartMessage)
                      (relation-asserted start_Q)
                      (valid-answers GoOnAdventures LordOfTheRing SpecialSnowflake DontLikeFantasy)))
)

(defrule choose_dont_like_fantasy ""
    (logical (start_Q DontLikeFantasy))
    =>
    (assert (UI-state (display DontLikeFantasyMessage)
                      (relation-asserted dontPlayDND)
                      (valid-answers vampire_ans)))
)

(defrule answer_dont_play_DND ""
    (logical (dontPlayDND vampire_ans))
    =>
    (assert (UI-state (display DontPlayDNDMessage)
                      (state final)))
)

(defrule choose_special_hero ""
    (logical (or
        (start_Q GoOnAdventures)
        (DarkWhiteDude DarkWhiteDude_yes)
        (Dragon Dragon_no)))
    =>
    (assert (UI-state (display SpecialHeroMessage)
                      (relation-asserted SpecialHero)
                      (valid-answers ElfOrSmth SwordAndMagic)))
)

(defrule choose_classic_fantasy ""
    (logical (or
        (start_Q LordOfTheRing)
        (SpecialHero ElfOrSmth)))
    =>
    (assert (UI-state (display ClassicFantasyMessage)
                      (relation-asserted ClassicFantasy)
                      (valid-answers SmthDiffrent MeToo)))
)

(defrule choose_what_makes_special ""
    (logical (or
        (start_Q SpecialSnowflake)
        (ClassicFantasy SmthDiffrent)))
    =>
    (assert (UI-state (display WhatMakesSpecialMessage)
                      (relation-asserted WhatMakesSpecial)
                      (valid-answers NoTrue WantToBeDragon NotElfDwarfETC)))
)

(defrule choose_how_dark ""
    (logical (WhatMakesSpecial NoTrue))
    =>
    (assert (UI-state (display DarkWhiteDudeMessage)
                      (relation-asserted DarkWhiteDude )
                      (valid-answers DarkWhiteDude_yes DarkWhiteDude_no)))
)

(defrule choose_dragon ""
    (logical (WhatMakesSpecial WantToBeDragon))
    =>
    (assert (UI-state (display DragonMessage)
                      (relation-asserted Dragon )
                      (valid-answers Dragon_yes Dragon_no)))
)


(defrule choose_PickColor ""
    (logical (Dragon Dragon_yes))
    =>
    (assert (UI-state (display PickColorMessage)
                      (relation-asserted PickColor )
                      (valid-answers YAY)))
)

(defrule answer_dragonborn ""
    (logical (or
        (PickColor YAY)
        (CloseEnough OkayFine)
        (KindOfScales ChooseDragon)))
    =>
    (assert (UI-state (display DragonbornMessage)
                      (relation-asserted Dragonborn)
                      (valid-answers NotDragon KidSized)
                      (state final)))
)

(defrule choose_CloseEnough ""
    (logical (Dragonborn NotDragon))
    =>
    (assert (UI-state (display CloseEnoughMessage)
                      (relation-asserted CloseEnough )
                      (valid-answers OkayFine NoLemmeDragon)))
)

(defrule answer_GetOut ""
    (logical (CloseEnough NoLemmeDragon))
    =>
    (assert (UI-state (display GetOutMessage)
                      (relation-asserted GetOut )
                      (state final)))
)

(defrule answer_kobold ""
    (logical (or
        (Dragonborn KidSized)
        (Scales Scales_Yes)))
    =>
    (assert (UI-state (display KoboldMessage)
                      (relation-asserted Kobold )
                      (state final)))
)

(defrule choose_KindOfMonstrous ""
    (logical (DarkWhiteDude DarkWhiteDude_no))
    =>
    (assert (UI-state (display KindOfMonstrousMessage)
                      (relation-asserted KindOfMonstrous )
                      (valid-answers NoOneGetsMe IWasMonster)))
)

(defrule choose_ComicRelief ""
    (logical (KindOfMonstrous IWasMonster))
    =>
    (assert (UI-state (display ComicReliefMessage)
                      (relation-asserted ComicRelief )
                      (valid-answers Funny_Q SlaughterLaughter)))
)

(defrule choose_Scales ""
    (logical (or
        (ComicRelief SlaughterLaughter)
        (ExtremelySilly DarkHumor)))
    =>
    (assert (UI-state (display ScalesMessage)
                      (relation-asserted Scales )
                      (valid-answers Scales_Yes Scales_No)))
)

(defrule choose_Power ""
    (logical (ComicRelief Funny_Q))
    =>
    (assert (UI-state (display PowerMessage)
                      (relation-asserted  Power)
                      (valid-answers PowerStrength PowerIntellect)))
)

(defrule answer_goblin ""
    (logical (or
        (Scales Scales_No)
        (Version VersionSmall)))
    =>
    (assert (UI-state (display GoblinMessage)
                      (relation-asserted Goblin)
                      (state final)))
)

(defrule choose_SurpriseAttack ""
    (logical (Power PowerStrength))
    =>
    (assert (UI-state (display SurpriseAttackMessage)
                      (relation-asserted  SurpriseAttack)
                      (valid-answers FaceThem JustLazy)))
)

(defrule choose_ABitOfStrength ""
    (logical (Power PowerIntellect))
    =>
    (assert (UI-state (display ABitOfStrengthMessage)
                      (relation-asserted  ABitOfStrength)
                      (valid-answers UltimateWeapon TacticalProwess)))
)

(defrule answer_yuan_ti ""
    (logical (or
        (ABitOfStrength UltimateWeapon)
        (TedCruz Snek)))
    =>
    (assert (UI-state (display YuanTiMessage)
                      (relation-asserted YuanTi)
                      (state final)))
)

(defrule answer_bugbear ""
    (logical (SurpriseAttack JustLazy ))
    =>
    (assert (UI-state (display bugbearMessage)
                      (relation-asserted bugbear)
                      (state final)))
)

(defrule answer_hobgoblin ""
    (logical (ABitOfStrength TacticalProwess))
    =>
    (assert (UI-state (display hobgoblinMessage)
                      (relation-asserted hobgoblin)
                      (state final)))
)

(defrule answer_orc ""
    (logical (or
        (SurpriseAttack FaceThem)
        (Version VersionBig)))
    =>
    (assert (UI-state (display orcMessage)
                      (relation-asserted orc)
                      (valid-answers IDontWant)
                      (state final)))
)

(defrule choose_version ""
    (logical (PartOfMonster HundredPercent))
    =>
    (assert (UI-state (display VersionMessage)
                      (relation-asserted Version)
                      (valid-answers VersionBig VersionSmall)))
)

(defrule choose_AnimalPerson ""
    (logical (WhatMakesSpecial NotElfDwarfETC))
    =>
    (assert (UI-state (display AnimalPersonMessage)
                      (relation-asserted AnimalPerson)
                      (valid-answers LikeFurry MoreSpecial)))
)

(defrule choose_WeirdWeirds ""
    (logical (AnimalPerson MoreSpecial))
    =>
    (assert (UI-state (display WeirdWeirdsMessage)
                      (relation-asserted WeirdWeirds)
                      (valid-answers WeirdWeirdsYes WeirdWeirdsNo)))
)

(defrule choose_UncommonRaces ""
    (logical (or
        (WeirdWeirds WeirdWeirdsNo)
        (LessClassic NoProblem)))
    =>
    (assert (UI-state (display UncommonRacesMessage)
                      (relation-asserted UncommonRaces)
                      (valid-answers MissionFromGod DCsuperhero BeepBoopBop
                            Doppelganger  ClassicMonster AnimalPersonQuestion)))
)

(defrule choose_PartOfMonster ""
    (logical (UncommonRaces ClassicMonster))
    =>
    (assert (UI-state (display PartOfMonsterMessage)
                      (relation-asserted PartOfMonster)
                      (valid-answers Nuanced HundredPercent)))
)




;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question

   (declare (salience 5))
   
   (UI-state (id ?id))
   
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))
             
   =>
   
   (modify ?f (current ?id)
              (sequence ?id ?s))
   
   (halt))

(defrule handle-next-no-change-none-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
                      
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-response-none-end-of-chain

   (declare (salience 10))
   
   ?f <- (next ?id)

   (state-list (sequence ?id $?))
   
   (UI-state (id ?id)
             (relation-asserted ?relation))
                   
   =>
      
   (retract ?f)

   (assert (add-response ?id)))   

(defrule handle-next-no-change-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
     
   (UI-state (id ?id) (response ?response))
   
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-change-middle-of-chain

   (declare (salience 10))
   
   (next ?id ?response)

   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
     
   (UI-state (id ?id) (response ~?response))
   
   ?f2 <- (UI-state (id ?nid))
   
   =>
         
   (modify ?f1 (sequence ?b ?id ?e))
   
   (retract ?f2))
   
(defrule handle-next-response-end-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)
   
   (state-list (sequence ?id $?))
   
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))
                
   =>
      
   (retract ?f1)

   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
      
   (assert (add-response ?id ?response)))   

(defrule handle-add-response

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id ?response)
                
   =>
      
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   
   (retract ?f1))   

(defrule handle-add-response-none

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id)
                
   =>
      
   (str-assert (str-cat "(" ?relation ")"))
   
   (retract ?f1))   

(defrule handle-prev

   (declare (salience 10))
      
   ?f1 <- (prev ?id)
   
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))
                
   =>
   
   (retract ?f1)
   
   (modify ?f2 (current ?p))
   
   (halt))
