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
        (TedCruz ChooseDragon)))
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

(defrule choose_furry ""
    (logical
        (or (AnimalPerson LikeFurry)
            (UncommonRaces AnimalPersonQuestion) ))
    =>
    (assert (UI-state (display furryMessage)
                      (relation-asserted furry)
                      (valid-answers MoreHorse BirdsCool OwO Scalie)))
)

(defrule answer_Changelings ""
    (logical (UncommonRaces Doppelganger))
    =>
     (assert (UI-state (display ChangelingsMessage)
                      (relation-asserted Changelings)
                      (state final)))
)

(defrule answer_Warforged ""
    (logical (UncommonRaces BeepBoopBop))
    =>
     (assert (UI-state (display WarforgedMessage)
                      (relation-asserted Warforged)
                      (state final)))
)

(defrule answer_Triton ""
    (logical (UncommonRaces DCsuperhero))
    =>
     (assert (UI-state (display TritonMessage)
                      (relation-asserted Triton)
                      (valid-answers MoreElfy)
                      (state final)))
)

(defrule answer_SeaElf ""
    (logical (or (Triton MoreElfy)
        (WhatsTheProblem Mermalds)))
    =>
     (assert (UI-state (display SeaElfMessage)
                      (relation-asserted SeaElf)
                      (state final)))
)

(defrule answer_Aasimar ""
    (logical (UncommonRaces MissionFromGod))
    =>
     (assert (UI-state (display AasimarMessage)
                      (relation-asserted Aasimar)
                      (valid-answers Tieflings)
                      (state final)))
)

(defrule choose_KindOfAngel ""
    (logical (Aasimar Tieflings))
    =>
    (assert (UI-state (display KindOfAngelMessage)
                      (relation-asserted KindOfAngel)
                      (valid-answers Goodness NameIsLord BadAngel)))
)

(defrule answer_Protector ""
    (logical (KindOfAngel Goodness))
    =>
     (assert (UI-state (display ProtectorMessage)
                      (relation-asserted Protector)
                      (state final)))
)

(defrule answer_Scourge ""
    (logical (KindOfAngel NameIsLord))
    =>
     (assert (UI-state (display ScourgeMessage)
                      (relation-asserted Scourge )
                      (state final)))
)

(defrule answer_Fallen ""
    (logical (or (KindOfAngel BadAngel) (Edgelord FallenFromGrace)))
    =>
     (assert (UI-state (display FallenMessage)
                      (relation-asserted Fallen)
                      (state final)))
)

(defrule choose_PeopleMisunderstand ""
    (logical (KindOfMonstrous NoOneGetsMe))
    =>
    (assert (UI-state (display PeopleMisunderstandnMessage)
                      (relation-asserted PeopleMisunderstand)
                      (valid-answers IamTheDark Parents LookLikeADevil LizardPerson)))
)

(defrule answer_HalfOrc ""
    (logical (or (PeopleMisunderstand Parents)
               (orc IDontWant)
               (PartOfMonster Nuanced)
               (HalfMonster MonsterBlood)))
    =>
    (assert (UI-state (display HalfOrcMessage)
                      (relation-asserted HalfOrc)
                      (state final)))
)

(defrule answer_TieFling ""
    (logical (PeopleMisunderstand LookLikeADevil))
    =>
    (assert (UI-state (display TieFlingMessage)
                      (relation-asserted TieFling)
                      (state final)))
)

(defrule choose_TedCruz ""
    (logical (or (PeopleMisunderstand LizardPerson) (furry Scalie)))
    =>
    (assert (UI-state (display TedCruzMessage)
                      (relation-asserted TedCruz)
                      (valid-answers GeneralReptiles Snek ChooseDragon)))
)

(defrule answer_lizardfolk ""
     (logical (TedCruz GeneralReptiles))
     =>
     (assert (UI-state (display lizardfolkMessage)
                      (relation-asserted lizardfolk)
                      (state final)))
)

(defrule answer_human ""
    (logical (SpecialHero SwordAndMagic))
    =>
    (assert (UI-state (display humanMessage)
                      (relation-asserted human)
                      (valid-answers WAAAAAIIIIT)
                      (state final)))

)

(defrule choose_whatisit ""
    (logical (human WAAAAAIIIIT))
    =>
    (assert (UI-state (display whatisitMessage)
                      (relation-asserted whatisit)
                      (valid-answers IsLame)))
)

(defrule choose_HalfMonster ""
    (logical (whatisit IsLame))
    =>
    (assert (UI-state (display HalfMonsterMessage)
                      (relation-asserted HalfMonster)
                      (valid-answers MagicalPretty MonsterBlood )))
)

(defrule answer_halfelf ""
    (logical (or (HalfMonster MagicalPretty) (WhatsTheProblem KindOfElfy)))
    =>
    (assert (UI-state (display halfelfMessage)
                      (relation-asserted halfelf)
                      (state final)))
)

(defrule choose_Edgelord ""
    (logical (PeopleMisunderstand IamTheDark))
    =>
    (assert (UI-state (display EdgelordMessage)
                      (relation-asserted Edgelord)
                      (valid-answers MeanDwarfness ElfDark FallenFromGrace )))
)

(defrule answer_duegar ""
    (logical (or (Edgelord MeanDwarfness) (HillsOrStronger IamAngry)))
    =>
    (assert (UI-state (display duegarMessage)
                      (relation-asserted duegar)
                      (state final)))
)

(defrule answer_Drow ""
    (logical (or (Edgelord ElfDark) (WhatsTheProblem DarkAndBrooding)))
    =>
    (assert (UI-state (display DrowMessage)
                      (relation-asserted Drow)
                      (valid-answers MoreDark)
                      (state final)))
)

(defrule answer_ShadarKai ""
    (logical (Drow MoreDark))
    =>
    (assert (UI-state (display ShadarKaiMessage)
                      (relation-asserted ShadarKai)
                      (state final)))
)

(defrule choose_HumanSized ""
    (logical (ClassicFantasy MeToo))
    =>
    (assert (UI-state (display HumanSizedMessage)
                      (relation-asserted HumanSized)
                      (valid-answers KidSize NoPedo BigSize)))
)

(defrule choose_StronkMen ""
    (logical (or (HumanSized BigSize) (LessClassic Giant)))
    =>
    (assert (UI-state (display StronkMenMessage)
                      (relation-asserted StronkMen)
                      (valid-answers BeGentl Mooscles)))
)

(defrule answer_firbolg ""
    (logical (StronkMen BeGentl))
    =>
    (assert (UI-state (display firbolgMessage)
                      (relation-asserted firbolg)
                      (state final)))
)

(defrule answer_goliath ""
    (logical (or (StronkMen Mooscles) (Dwarf NotShort)))
    =>
    (assert (UI-state (display goliathMessage)
                      (relation-asserted goliath)
                      (state final)))
)

(defrule choose_nPrettynSwole ""
    (logical (HumanSized NoPedo))
    =>
    (assert (UI-state (display nPrettynSwoleMessage)
                      (relation-asserted nPrettynSwole)
                      (valid-answers FeelPretty LiftBro DontLikeOPT)))
)

(defrule choose_LessClassic ""
    (logical (nPrettynSwole DontLikeOPT))
    =>
    (assert (UI-state (display LessClassicMessage)
                      (relation-asserted LessClassic)
                      (valid-answers Giant NoProblem)))
)

(defrule answer_Dwarf ""
    (logical (nPrettynSwole LiftBro))
    =>
    (assert (UI-state (display DwarfMessage)
                      (relation-asserted Dwarf)
                      (valid-answers NotShort TimeToDrink)
                      (state final)))
)

(defrule choose_HillsOrStronger ""
    (logical (Dwarf TimeToDrink))
    =>
    (assert (UI-state (display HillsOrStrongerMessage)
                      (relation-asserted HillsOrStronger)
                      (valid-answers HardynHilly StoneisStrength IamAngry ) ))
)

(defrule answer_HillDwarf
    (logical (HillsOrStronger HardynHilly))
    =>
    (assert (UI-state (display HillDwarfMessage)
                      (relation-asserted HillDwarf)
                      (state final) ))
)

(defrule answer_MountainDwarf
    (logical (HillsOrStronger StoneisStrength))
    =>
    (assert (UI-state (display MountainDwarfMessage)
                      (relation-asserted MountainDwarf)
                      (state final) ))
)

(defrule answer_Elf ""
    (logical (nPrettynSwole FeelPretty))
    =>
        (assert (UI-state (display ElfMessage)
                      (relation-asserted Elf)
                      (valid-answers ImDone)
                      (state final)))
)

(defrule choose_GetsComplicated ""
    (logical (Elf ImDone))
    =>
    (assert (UI-state (display GetsComplicatedMessage)
                      (relation-asserted GetsComplicated)
                      (valid-answers MadeOfMagic TreeHuggers NoneOfThis)))
)

(defrule answer_HighElf ""
    (logical (GetsComplicated MadeOfMagic))
    =>
    (assert (UI-state (display HighElfMessage)
                      (relation-asserted HighElf)
                      (state final)))
)

(defrule answer_WoodElf ""
    (logical (GetsComplicated TreeHuggers))
    =>
    (assert (UI-state (display WoodElfMessage)
                      (relation-asserted WoodElf)
                      (state final)))
)

(defrule choose_WhatsTheProblem ""
    (logical (GetsComplicated NoneOfThis))
    =>
    (assert (UI-state (display WhatsTheProblemMessage)
                      (relation-asserted WhatsTheProblem)
                      (valid-answers ElvesFaeries Mermalds KindOfElfy DarkAndBrooding)))

)

(defrule answer_Eladrin ""
    (logical (WhatsTheProblem ElvesFaeries))
    =>
    (assert (UI-state (display EladrinMessage)
                      (relation-asserted Eladrin)
                      (state final)))
)

(defrule choose_ExtremelySilly ""
    (logical (HumanSized KidSize))
    =>
    (assert (UI-state (display ExtremelySillyMessage)
                      (relation-asserted ExtremelySilly)
                      (valid-answers Gravitas MagicGlitter DarkHumor)))
)

(defrule answer_halfling ""
    (logical (ExtremelySilly Gravitas))
    =>
    (assert (UI-state (display halflingMessage)
                      (relation-asserted halfling)
                      (valid-answers offBrandHobbit)
                      (state final)))
)

(defrule choosing_DwarfyOrNumble ""
    (logical (halfling offBrandHobbit))
    =>
    (assert (UI-state (display DwarfyOrNumbleMessage)
                      (relation-asserted DwarfyOrNumble)
                      (valid-answers Hardy Nimble)))
)

(defrule answer_stout ""
    (logical (DwarfyOrNumble Hardy))
    =>
    (assert (UI-state (display stoutMessage)
                      (relation-asserted stout)
                      (state final)))
)

(defrule answer_lightfoot ""
    (logical (DwarfyOrNumble Nimble))
    =>
    (assert (UI-state (display lightfootMessage)
                      (relation-asserted lightfoot)
                      (state final)))
)

(defrule answer_gnome ""
    (logical (ExtremelySilly MagicGlitter))
    =>
    (assert (UI-state (display gnomeMessage)
                      (relation-asserted gnome)
                      (valid-answers MagicHobbit)
                      (state final)))
)

(defrule choosing_Trickster ""
    (logical (gnome MagicHobbit))
    =>
    (assert (UI-state (display TricksterMessage)
                      (relation-asserted Trickster )
                      (valid-answers Mushroom Toys) ))
)

(defrule answer_ForestGnome ""
    (logical (Trickster Mushroom))
    =>
    (assert (UI-state (display ForestGnomeMessage)
                      (relation-asserted ForestGnome)
                      (state final)))
)

(defrule answer_MountainGnome ""
    (logical (Trickster Toys))
    =>
    (assert (UI-state (display MountainGnomeMessage)
                      (relation-asserted MountainGnome)
                      (valid-answers GoDeeper)
                      (state final)))
)

(defrule answer_DeepGnome ""
    (logical (MountainGnome GoDeeper))
    =>
    (assert (UI-state (display DeepGnomeMessage)
                      (relation-asserted DeepGnome)
                      (state final)))
)

(defrule answer_centaur ""
    (logical (furry MoreHorse))
    =>
    (assert (UI-state (display CentaurMessage)
                      (relation-asserted Centaur)
                      (state final)))
)

(defrule choose_fursona ""
    (logical (furry OwO))
    =>
    (assert (UI-state (display fursonaMessage)
                      (relation-asserted fursona)
                      (valid-answers Cat Cow Elephant None)))
)

(defrule answer_tabaxi ""
    (logical (fursona Cat))
    =>
    (assert (UI-state (display TabaxiMessage)
                      (relation-asserted Tabaxi)
                      (state final)))
)

(defrule answer_minotaur ""
    (logical (fursona Cow))
    =>
    (assert (UI-state (display MinotaurMessage)
                      (relation-asserted Minotaur)
                      (state final)))
)

(defrule answer_loxadon ""
    (logical (fursona Elephant))
    =>
    (assert (UI-state (display LoxadonMessage)
                      (relation-asserted Loxadon)
                      (state final)))
)

(defrule answer_shifter ""
    (logical (fursona None))
    =>
    (assert (UI-state (display ShifterMessage)
                      (relation-asserted Shifter)
                      (state final)))
)

(defrule choose_EagleOrCorvid ""
    (logical (furry BirdsCool))
    =>
    (assert (UI-state (display EagleOrCorvidMessage)
                      (relation-asserted EagleOrCorvid)
                      (valid-answers WannaSoar CawCaw)))
)

(defrule answer_aarakocra ""
    (logical (EagleOrCorvid WannaSoar))
    =>
    (assert (UI-state (display AarakocraMessage)
                      (relation-asserted Aarakocra)
                      (state final)))
)

(defrule answer_kenku ""
    (logical (EagleOrCorvid CawCaw))
    =>
    (assert (UI-state (display KenkuMessage)
                      (relation-asserted Kenku)
                      (state final)))
)

(defrule choose_ParentGenie ""
    (logical (WeirdWeirds WeirdWeirdsYes))
    =>
    (assert (UI-state (display ParentGenieMessage)
                      (relation-asserted ParentGenie)
                      (valid-answers YeahThatWorks WillSmith)))
)

(defrule choose_MultiverseDwelling ""
    (logical (ParentGenie WillSmith))
    =>
    (assert (UI-state (display MultiverseDwellingMessage)
                      (relation-asserted MultiverseDwelling)
                      (valid-answers OkayThatsPretty UglyElves)))
)

(defrule choose_HairlessVulcan ""
    (logical (MultiverseDwelling UglyElves))
    =>
    (assert (UI-state (display HairlessVulcanMessage)
                      (relation-asserted HairlessVulcan)
                      (valid-answers Fine SpaceElves)))
)

(defrule choose_TentaclesAndMutations ""
    (logical (HairlessVulcan SpaceElves))
    =>
    (assert (UI-state (display TentaclesAndMutationsMessage)
                      (relation-asserted TentaclesAndMutations)
                      (valid-answers ThisIsWhatImTalkingAbout Mysterious)))
)

(defrule answer_genasi ""
    (logical (ParentGenie YeahThatWorks))
    =>
    (assert (UI-state (display GenasiMessage)
                      (relation-asserted Genasi)
                      (valid-answers CaptainPlanet)
                      (state final)))
)

(defrule choose_GeniesAreElemental ""
    (logical (Genasi CaptainPlanet))
    =>
    (assert (UI-state (display GeniesAreElementalMessage)
                      (relation-asserted GeniesAreElemental)
                      (valid-answers OneRealChoice RockHard WeAllFloat Aquaman)))
)

(defrule answer_FireGenasi ""
    (logical (GeniesAreElemental OneRealChoice))
    =>
    (assert (UI-state (display FireGenasiMessage)
                      (relation-asserted FireGenasi)
                      (state final)))
)

(defrule answer_EarthGenasi ""
    (logical (GeniesAreElemental RockHard))
    =>
    (assert (UI-state (display EarthGenasiMessage)
                      (relation-asserted EarthGenasi)
                      (state final)))
)

(defrule answer_AirGenasi ""
    (logical (GeniesAreElemental WeAllFloat))
    =>
    (assert (UI-state (display AirGenasiMessage)
                      (relation-asserted AirGenasi)
                      (state final)))
)

(defrule answer_WaterGenasi ""
    (logical (GeniesAreElemental Aquaman))
    =>
    (assert (UI-state (display WaterGenasiMessage)
                      (relation-asserted WaterGenasi)
                      (state final)))
)

(defrule answer_gith ""
    (logical (MultiverseDwelling OkayThatsPretty))
    =>
    (assert (UI-state (display GithMessage)
                      (relation-asserted Gith)
                      (valid-answers ExplodeHeads)
                      (state final)))
)

(defrule choose_GithComeInTwoFlavors ""
    (logical (Gith ExplodeHeads))
    =>
    (assert (UI-state (display GithComeInTwoFlavorsMessage)
                      (relation-asserted GithComeInTwoFlavors)
                      (valid-answers WeAreImmortal ZenKungFu)))
)

(defrule answer_githyanki ""
    (logical (GithComeInTwoFlavors WeAreImmortal))
    =>
    (assert (UI-state (display GithyankiMessage)
                      (relation-asserted Githyanki)
                      (state final)))
)

(defrule answer_githzerai ""
    (logical (GithComeInTwoFlavors ZenKungFu))
    =>
    (assert (UI-state (display GithzeraiMessage)
                      (relation-asserted Githzerai)
                      (state final)))
)

(defrule answer_vedalken ""
    (logical (HairlessVulcan Fine))
    =>
    (assert (UI-state (display VedalkenMessage)
                      (relation-asserted Vedalken)
                      (state final)))
)

(defrule answer_SimicHybrid ""
    (logical (TentaclesAndMutations ThisIsWhatImTalkingAbout))
    =>
    (assert (UI-state (display SimicHybridMessage)
                      (relation-asserted SimicHybrid)
                      (state final)))
)

(defrule answer_Kalashtar ""
    (logical (TentaclesAndMutations Mysterious))
    =>
    (assert (UI-state (display KalashtarMessage)
                      (relation-asserted Kalashtar)
                      (valid-answers IDontKnowWhatThisIs)
                      (state final)))
)

(defrule answer_BanningYou ""
    (logical (Kalashtar IDontKnowWhatThisIs))
    =>
    (assert (UI-state (display BanningYouMessage)
                      (relation-asserted BanningYou)
                      (state final)))
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
