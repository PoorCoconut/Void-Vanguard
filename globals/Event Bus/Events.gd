extends Node
#The Events bus is a place where you can pass around signals in a clean manner
#Below is an example of a signal. This signal is connected via code in the PlayerHUD


signal player_hp_updated(current_hp, max_hp)
signal enemy_progress(prog : float)
signal bought_hull_upgrade()
signal do_bf()
signal complete_game()

signal change_melody(type : String)
signal do_drums(enable : bool)
