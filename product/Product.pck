GDPC                �                                                                          X   res://.godot/exported/133200997/export-2bc2da292bf5f8577c1a793715b24012-minecraft.res   �"      a      ���ኅ�GX&C^V�a    T   res://.godot/exported/133200997/export-75187f5b8f76bb0bea9ac8c296bdda67-gameplay.scn�      �      �!>����7B���?�*    ,   res://.godot/global_script_class_cache.cfg   S      �       �0|a9q�_����\�v�    T   res://.godot/imported/minecraft_font.ttf-02aa0851a24f9f1a669e7ae39107d350.fontdata   $      ?      ���z�jO��gX���b    L   res://.godot/imported/paper_hover.png-95f092fd5cc24bc8d63f8799e0d2ea86.ctex �;      �       +eu\\B���5���8    L   res://.godot/imported/paper_normal.png-9e08d22c7ff069c658544371a6d03beb.ctex�=      �       ��YGD���>�D��    P   res://.godot/imported/paper_pressed.png-2c63fa40e5c513dbbe2fe3b2dfa0a9be.ctex   ?      �       ?��=�/,Ǯ���K Y    L   res://.godot/imported/rock_hover.png-cbbf8103cfe76da35d723fe0523bc71b.ctex   A      �       쪕K�g��f��    L   res://.godot/imported/rock_normal.png-f8d384df26a19dc8d2ec63b8770710b7.ctex �B      �       �I~ �I��ݒ����    L   res://.godot/imported/rock_pressed.png-b678799f20d8576c71edf83d47bff938.ctexPD      �       �0kW^�}7*�2�(��    P   res://.godot/imported/scissors_hover.png-ad5acfed88db0c0386d2b362a3317657.ctex  @K      �       ���㥩��s݇�l���    P   res://.godot/imported/scissors_normal.png-d9f1932440b74fc2ccd74aab6ed3cb54.ctex M      �       �!�f8ۖ^F�_4    P   res://.godot/imported/scissors_pressed.png-4e98f532ca9c22bfd9872e77dd4c033a.ctex�N      �       �8X��*t�9��    P   res://.godot/imported/unknown_choice.png-1af4bef2da7ccfc91f2c676c9f934fec.ctex  �P      �       �`u�-E�jظ��i�       res://.godot/uid_cache.bin  �S      �      #?�IEDW`3��A       res://gameplay.gd           �      ����s��M\����by       res://gameplay.tscn.remap    R      e       ��b2�<Ɗ����F       res://minecraft.tres.remap  �R      f       �>��_�Wϵ�4�P�        res://minecraft_font.ttf.import @;      �       .
�C���e7�'
({G       res://paper_hover.png.import�<      �       Սdk�G�F����        res://paper_normal.png.import   @>      �       o�����Ī&�j𴱨        res://paper_pressed.png.import  �?      �       p��}�%���r��       res://playerchoice.gd   �@      \       +��2�@h���.3'K       res://project.binary`U      2       ]G��(*j���ew       res://rock_hover.png.import �A      �       ٚu(<�5eއ=�j���       res://rock_normal.png.import�C      �       ��*�sRITu����3�        res://rock_pressed.png.import    E      �       @}����F�1���       res://rpsm.gd   �E      G      �H^�F��(��%F(�V        res://scissors_hover.png.import @L      �       =Q�rfr=�v6����        res://scissors_normal.png.import N      �       ����J�@�����[    $   res://scissors_pressed.png.import   �O      �       �_��{[P*!��z)��        res://unknown_choice.png.import PQ      �       �\�:�-`���cl�#v            extends Control


const SAVE_FILE_PATH = "user://savedata.idk"


var player_buttons : Array
var ai_images : Array
var ai_unknown : TextureRect
var ai = RPSM.new()
var status_label : Label
var score_label : Label
var gamestats_label : RichTextLabel
var gameover : Node
var player_score = 0
var ai_score = 0
var rounds_played = 0


func player_selected(origin):
	origin.disabled = true
	for node in player_buttons:
		if node == origin: continue
		node.disabled = false
		node.button_pressed = false


func player_lock():
	for node in player_buttons: 
		if node.button_pressed: continue
		node.visible = false
		node.disabled = true


func player_unlock():
	for node in player_buttons: 
		if node.button_pressed: continue
		node.disabled = false
		node.visible = true


func player_throw() -> int:
	for node in player_buttons:
		if !node.button_pressed: continue
		name = node.get_name()
		if   name == "ScissorsButton": return 0
		elif name == "RockButton":     return 1
		elif name == "PaperButton":    return 2
		else: return -1
	return -1


func ai_lock(ai_throw):
	ai_unknown.visible = false
	for node in ai_images:
		name = node.get_name()
		if (name == "AIpaper" && ai_throw == 2) \
		|| (name == "AIrock" && ai_throw == 1) \
		|| (name == "AIscissors" && ai_throw == 0):
			node.visible = true
			return


func ai_unlock():
	for node in ai_images: node.visible = false
	ai_unknown.visible = true


func game_start():
	gameover.visible = false
	ai.adapt(2)
	player_score = 0
	ai_score = 0
	rounds_played = 0
	score_label.text = "0:0"
	round_start()


func round_start():
	player_unlock()
	ai_unlock()
	for i in range(3, 0, -1):
		status_label.text = "Choose! Throw in " + str(i)
		await get_tree().create_timer(1.0).timeout
	round_finish()


func round_result(player_throw : int, ai_throw : int) -> int:
	if player_throw == ai_throw: return 0
	elif player_throw > ai_throw:
		if player_throw == 2 && ai_throw == 0: return -1
		return 1
	else:
		if player_throw == 0 && ai_throw == 2: return 1
		return -1


func round_finish():
	rounds_played += 1
	player_lock()
	var trw1 = player_throw()
	var trw2 = ai.throw()
	ai_lock(trw2)
	var round_result = round_result(trw1, trw2)
	ai.adapt(-round_result)
	var game_result = round_update_ui(round_result)
	if game_result == 0:
		await get_tree().create_timer(2.0).timeout
		round_start()
		return
	var main_str = ""
	if game_result == 1:
		main_str = "You won the game! Exiting in "
	else:
		main_str = "You lost the game! Exiting in "
	for i in range(3, 0, -1):
		status_label.text = main_str + str(i)
		await get_tree().create_timer(1.0).timeout
	gameover.visible = true
	stats_update(game_result, rounds_played, player_score, rounds_played - ai_score - player_score)
	gamestats_label.text = "\
Games played: %d\n\
Games won: %d\n\
Rounds played: %d\n\
Rounds won: %d\n\
Rounds tied: %d\n\
" % stats_get()


func round_update_ui(round_result : int) -> int:
	if round_result == 0:
		status_label.text = "Round tied!"
		return 0
	elif round_result == 1:
		player_score += 1
		score_label.text = str(player_score)+":"+str(ai_score)
		status_label.text = "Round won!"
		if player_score >= 3:
			return 1
	else:
		ai_score += 1
		score_label.text = str(player_score)+":"+str(ai_score)
		status_label.text = "Round lost!"
		if ai_score >= 3:
			return -1
	return 0


func stats_update(game_result : int, rounds_amount : int, rounds_won : int, rounds_tied : int):
	var data = stats_get()
	data[0] += 1
	if game_result == 1: data[1] += 1
	data[2] += rounds_amount
	data[3] += rounds_won
	data[4] += rounds_tied
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	for d in data: file.store_32(d)

func stats_get() -> Array:
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file == null || file.get_error() == ERR_FILE_CANT_OPEN: return [0, 0, 0, 0, 0]
	var data = []
	for i in 5: data.append(file.get_32())
	return data


func _ready():
	player_buttons = [
		get_node("ScissorsButton"),
		get_node("PaperButton"),
		get_node("RockButton"),
	]
	for node in player_buttons:
		node.just_pressed.connect(player_selected)
	ai_unknown = get_node("AIunknown")
	ai_images = [
		get_node("AIscissors"),
		get_node("AIrock"),
		get_node("AIpaper"),
	]
	status_label = get_node("StatusLabel")
	score_label = get_node("ScoreLabel")
	gamestats_label = get_node("GameoverBG/GameStats")
	gamestats_label.text = "\
Games played: %d\n\
Games won: %d\n\
Rounds played: %d\n\
Rounds won: %d\n\
Rounds tied: %d\n\
" % stats_get()
	gameover = get_node("GameoverBG")
	get_node("GameoverBG/RestartButton").pressed.connect(game_start)
               RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://gameplay.gd ��������
   Texture2D    res://scissors_normal.png OT�JD
   Texture2D    res://scissors_pressed.png �Gп�r[
   Texture2D    res://scissors_hover.png dI���_   Script    res://playerchoice.gd ��������
   Texture2D    res://rock_normal.png f8�iO

   Texture2D    res://rock_pressed.png 3��/?�6
   Texture2D    res://rock_hover.png �#�<�Ȓc
   Texture2D    res://paper_normal.png �5��P�
   Texture2D    res://paper_pressed.png �I�+E'�'
   Texture2D    res://paper_hover.png ��E�l
   Texture2D    res://unknown_choice.png �q�wY��   Theme    res://minecraft.tres xaJed      local://PackedScene_r8v65 S         PackedScene          	         names "   1      Node2D    layout_mode    anchors_preset    size_flags_horizontal    size_flags_vertical    script    Control    ScissorsButton    offset_left    offset_top    offset_right    offset_bottom    toggle_mode    texture_normal    texture_pressed    texture_hover    texture_disabled    stretch_mode    TextureButton    RockButton    PaperButton 	   disabled    button_pressed 
   AIunknown    texture    TextureRect    AIscissors    visible    AIrock    AIpaper    StatusLabel    theme    text    horizontal_alignment    vertical_alignment    Label    ScoreLabel    GameoverBG    color 
   ColorRect    StatsBG    scale 
   GameStats +   theme_override_font_sizes/normal_font_size    RichTextLabel    ResultLabel $   theme_override_font_sizes/font_size    RestartButton    Button    	   variants    G                                           TC     'C     �C    ��C                                                A     �B                                      �B     SC               	         
        �C     &C     D     �C                     C     B     �C     `B               Made for school project            �C    ��C      0:0      ��     D    ��C   �� <    ��0=��O?     �A     RC     �B     mC
   D�A�*�@               ��O?     B     WC     �C     �C                K   Games played: 0
Games won: 0
Rounds played: 0
Rounds won: 0
Rounds tied: 0      -C     |B    ��C     +C   @         RPS_AI      �C    ��C     �C     �C
      @   @   
         Play again       node_count             nodes     }  ��������       ����                                                    ����               	      
                           	      
                                                   ����               	      
                           	                                                         ����               	      
                           	      	      	                                                         ����               	      
                                    ����                     	      
                                    ����                     	      
                                    ����                     	      
                              #      ����	               	       
   !      "      #       $   !   %   "   %               #   $   ����	            &   	      
   '             #       (   !   %   "   %               '   %   ����         	   )   
   *      +   &   ,       
       '   (   ����            -   	   .   
   /      0   )   1   &   2       
       ,   *   ����
            3   	   4   
   5      6            7      #   +   8       9       
       #   -   ����            :   	   ;   
   <      =                   #   .   >       ?   !   %   "   %       
       0   /   ����
            @   	   A   
   B      C   )   D      E      7      #       F             conn_count              conns               node_paths              editable_instances              version             RSRC            RSRC                    Theme            ��������                                                  resource_local_to_scene    resource_name    default_base_scale    default_font    default_font_size    script    	   FontFile    res://minecraft_font.ttf (0��I      local://Theme_7wj1e 7         Theme                       RSRC               RSCC      =  �  �  �  �  (�/�` E? Ja|I�ZuƄEϛ�b� �����c4�CI�
�J�3 `�2�$��l��@Q���c������4S�u["e
&lSlp]v��Nt�4خ>���>,���U�����c]��ڿvM�O��nXm�_�u}����"��T�������]���L7q
n7��?����ͪ�7�m�U���[�1���7ܮB�R]`:��;��2\�������V-���;��{��ת����n�뛲�mU�o�٨��\����Ĕ�R+*�v��EX\��ov
~�����뫮��­��/Q�a�a�����sV/�
Ų*��{����v��ԅSV��l�}�(���� ��~�O~�+ܺL�a�Y����hl$�l���1�Xg�1�T���h�M���/:z =�$[�l�L�����6978��޶1��?��c�G*�\�ew�ē��f��\�?��[ QE���(G�.��@迆�;9��ԡ��[Vol$ɿ1�A��5R�Ph �.饥n��?��ޔ����Fޟ��g�Ŝ�Sl���I�x$�jp���ǡ�.��ȿ��HsQ�����S�sÈW"D�J<g�p!��4�~%HHP���\�|�����<�}!�<^�?�ĵ�s��a��[�U�ە-�_%���+�!9d�RV�Q��\UK��#�:�"�(�C`�� � R����'�O��Ӎ�����͇h�`�e�����X��>| �t�����Q�aC�B��=�$�Z�%<T<N<C<afAf����LϺ�١��`��&��YYQf@�%&$�#�Cka`A03� /�W�W����.���r��ZH�UkK
��$�vU�CR�/H!��*�C���J��Tٖ���9(8���/~���.ҧ,V�H�ℓ��$F�⃇6h���ႅ
�	Υ^JIHGL#E��$@@t@g 7�*T    ������C����b����Z��Њ�K���#��Ȉ�׸�}��� zT����'\;���{y�׾�s�ҡ��_���G�˥ֺ����>�����.�㌢7��s.��Z��=יw��_���/C�8�I��ˬ���wI��;\�w���߽�kw�1�1Ή�Ĩ�H���r�(�t�4�y3�K3�,]�di��y�w7Sw3�L�+~�n��n����{��a$z��8Ϋ���F��|��|�X�����cF�9�&�s�w��e��|�.�N�9ܟ���8?�ɚܑe��8�]z��F�U�����2��3��.�r�SDS�����r=&Q���UKqr�U�"��(�u�]��CȌ����H�$��H1�S`U%
�J͈Ф �ʴg;�k� 7�J���\ �hE7ۋ[h�e�_��@�u��]h^Sn��[�4��7Wk���+\���tDm$JP���o`���zK��;���i�[
h��
��*�1���I��^���_�i�[��|.2?P�h!�"O�Ф���0t�O`r�~��}�	��9Yq3-14�v���/^�q8�)�$R�Kp��%b���4�ӷ�c�c�	���#�}(Bѧ�O �/�X6�#���_e�����93[���-z��%>a���t�PFC��U�4_r�b;6�� �@#�X���3ϊ�SR�Z�C�����p�0y���MP8,�e���$ecb� 9�����e�TH�3fPܷ�O˂$ۇu]�<ҜDߤ����;���M-�3�ș��榌���»9��}��↚�M_�.��O��P'ʗ���{O����R{��)��A��\t���<U���AX~Ӝ��|��%1
p���>ʰ� RT����-��}���8'����$,���Q�?��_?�#q�;r礪��hP7z$�-��QAAV��Wt�M �d|����X1ϲ��<du}�h�D.�s���^�q�ل�%E��Ɓ��o�o�j�5e�$�q!É���mh*ݧ F��e�жDJ;3F L��-�Q�ı�4 (�/�` U$ �j.�'I�����]�4���_��@ƶ���>i7��V��vk�7͒��&r�W [ c ,%R��6�cqˢ�<���"�~��fY�z>Q�M0�~�a��>	?ߔ|�%�6���m眏{�
�W�7�}߾,ɷ�W����
��?w��1�pF�x�dww�+�q0�#�}�X�x�0S�E�BP��]�ff� �/�*�|� 9��I���Z;�L�/*`7�`�ƹ7\�����O������b�;G%�d�D�.�q�a��j������iڤ�H��R�f��Y�B���	�E�����;�x�A�&tI�;~_O�D���>�� ���kԛ��-6? E�=��L�hT�J͂��E�]%9����8��J��>���1-3�E�%��"�&��IQbb�^��5�T�ŀ�iϤO�-V�i�8w/�]���"���$)c�� �$���S)Ƒ�B� C�d&�D�� I:M��	p�A2��@i����_�3�}��4���|Q��[4��ߨ�)>�p �ch����iʘF�%�)D�!��:�a�����x�2��; ~{��xfΔM59I�Ci��/�UW1H|T�a�L��TA���=�^隕<*���>�W8��z��2����w�n�ɯh;7�|/�{�1sqѡ\��_�E�6=KU���F�5S�������(S�2X
S|.��4�]�n�\WO��湃;j(��i�|i"��kέ���a�i_ ���4l1�
�I��le��� ��}��G�P�a�c>�Y}e��o'��\����Hi;:�>Z���[ ��pw��{E�����b�T/9�ౢZh0�gu�#+�AR��WUį���3�/N�.2�=�*"�
�����]1T�.�f�r}[Lg@v��a�,���\!�bqps���~������ ��.z�́$��=�zGhU�)A[��#�P���^��|���R\�R�R�!"0sf+f�g}{�&�6Y{kJ�^�������!/�?��I��z�!8?��%��כ&$�=�w�0� ݔڐ�MG��������<�_��Vһ4M���������ңx�xRAd����EB#������	K�v>�ظd��S����>�ɠ���n����i8�@�뫟��7:4[(�/�` �' ��t,�'I��ݥ��sffz�7���mB�����+�o�iC��!dK�Rd i l V����Pϰ!�����8��'zvh_�:�B����i�������b/;����/��"!��V��3Ԛ�{�/�v.��v���������zvM���r}�8N�V�8�`N�R��^�����ڼ݊�@�!؍��8��x�Z�|p&�5��Ka���;����`�Bx�<�	���tu�/���V�����^�3��10�h��`���a&z���>i����	5�v\?`V��L��h�����^��4)W�J5�^�{gHs��0
;���u�U-�@r�]�3x=+���[�z� v��b����B����p�#Y��m�R��ýs��qM³DU���V^|���I�I���w_�TOEK�pL ݳ��Q�F�>�)���X�T�D�;���Ё��qIS2"��$�p �{@c%���R� 2R""A$IR)s&��[8a@%$�!n���C��"g����F�%r�sڬ����f�7�w�WT'�/�j��{u޻M!Q`.��m>��^�N|�+_��\�9GU�Y�;ۿ���JwzP�@s[G�_�/�Aḇ�k�H`�h�\�?�-|���c҃-�����S�
�K�C`��5ڧ׆�x}���
����縵��
mnP��W�^�2p�&y�+��!N<U���)����ßt`���ƿ�8��$��O�-�����\�v ��a�`C�W��:m_A��&�gΛ�� ;v t���5�H��0� �"�Ʃ~���
!�2�寣ƪ������!�K�e��z,+�'JM�.I��
���K&�ON<�fL�A�v�R�.+�2�`4Xsө�o��F����Q�Q�^&|D�ځak<pc�����1q�,z�_� �+�N����r˕����Ӭk��!1�_���; ��P$8E@��5'��92�@-�	+��3�ID��b�tFˤ�Uq�2�E�Y̷�!����m��C	V{fc-�7��1��]�LdϢk�hq��-�C�b6��!u|�P��h�)����<mf�� ��c� �f���l�^�/Ts�hs�bI�`h
ƴ2l6A����xo'�"��WY�ǈUq-F�0�ڬW����x��EP'eDANn�`u��V�f�@d���G���6���қ'�.�%����:`�8@��qH!�r�?"fg�ң_��(�/�`�, �F�F�'�AqJ�P�30�F\�i1Rp)G0�1\�*"���� �]��D�UE$�C_�/������L� � � �~!�X����?/rY�[nR�"7�~�g~9{�a��ײV�a�6���8Sa��`�m淗�~�Ul�Z��K�s���a�r6{���a�m�m�l�]��V��8қ�x��k�r��h�]���jط��a�}3�5����V��ZWY"i[�4�[Pr4m�as��j�-����MS��i�9;�a�װ��_���a�Y�0\�iR/è�E�z�E�Fp?9���foל`�gvY��G�k�-�r���NJZMrSr���g��3��*ָj}���ju��6C#Hm�6��ms�˨��&�H�z��s�6��r�<�5��E-r��Ig�<��ҥ^��Pj�[pK���ș&]p5�����4��Ң������k���c_��a����	8]7J�|�N.~t7a���G�}����	B�8���A���)�)��9�')ԏO
H�c��j�y���>�h�?ޱϪwƲ�!)�Ɩ,��nI� Ǜe^�.��CV0�d�ב,c:�,z,����j�΋���r�%���Y5�$����)n�j$�Q	Roe�{�3��>���+>����9p;*V�h��rJ��Qkt�/�[���J��%��d�$
�&,({�x��]�Q UЇ���:T*(�Vn��L�*#��C������۸�4���c����,^��S������x�"1� ���w����9��ogæ/�maz
O�f	sG�������`ңk^��������	<��1f�`�,���P��!-TH͈�DI����)Ĥ�<���B�����HRP�J�a-���3�|�g]=@��c����!	8�]\#Rt6ߕ|�1b���� � �E|y��T���{eٸU����J�́��o�C��i�s���2B�a�7S2yw���Bӊ8$=��^Hf���h�� ~��8�UY�d��&#�w��չ�h��	�a���#�g�
y�r��*	 0�)ÒU �	6�	����$�IXգ!��E���!��6/}BL�{�0��q�P�s�Q�3*l�a�R�6��,�ދO;+���'Z,2g`G�qbS���&��l���d��; �ݫi��S`�U�RA6������w����"'�
O�H]����I�,��ӂĠ�:*�^���yO�,K��H��a����I�Y�'H�s/�?|��N~c ����_5*eb3��v���p��c�zݹ\�V�M�3��"�J.87���h�G�Q���/�$:��9�+@×�k�6�|b�K�4t��mG^����B)ޠܩ3�';���F���jV�<?���aphz������a\mg��_��k4�{_�gz|�g���(�����x�3��RSCC [remap]

importer="font_data_dynamic"
type="FontFile"
uid="uid://chvwm43vnyt2w"
path="res://.godot/imported/minecraft_font.ttf-02aa0851a24f9f1a669e7ae39107d350.fontdata"
      GST2            ����                        �   RIFF�   WEBPVP8Ls   /� 7@&`�:�?d�ĥ� EvX�1���Y�w��������J�%Fm#I�f�Ea4�"p��è�s���.���O@�4�+ǚ� �W�n������O	����O��\鈖 [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://6iajkuc8i8sm"
path="res://.godot/imported/paper_hover.png-95f092fd5cc24bc8d63f8799e0d2ea86.ctex"
metadata={
"vram_texture": false
}
          GST2            ����                        �   RIFFx   WEBPVP8Ll   /� /@`2��?�DҕA Iq쯲�@�i��V������? �͝��HV뀃>D�WAb����:����Mc̴��� `^������ݟ�C/����M        [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://60weq6e6vsqu"
path="res://.godot/imported/paper_normal.png-9e08d22c7ff069c658544371a6d03beb.ctex"
metadata={
"vram_texture": false
}
         GST2            ����                        �   RIFFz   WEBPVP8Lm   /� /���$h?���X�3:�l����a�9Y����oH<� �o��XW�A$�u�A��� 1P�rރiD��1f�Vvj ���n�M`�f	��O���IzF��       [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bgtk8tnj13cxr"
path="res://.godot/imported/paper_pressed.png-2c63fa40e5c513dbbe2fe3b2dfa0a9be.ctex"
metadata={
"vram_texture": false
}
       extends TextureButton

signal just_pressed(node)

func _pressed():
	just_pressed.emit(self)
    GST2            ����                        �   RIFF�   WEBPVP8L�   /� ?���$�����z�=�E��6����ܜ� �Aa���lB� Ԩ��y�!h:x�ƶň�ܡ� w���?~@;����P-�\�����a*�� l�b�. �b�0 MP�X-8�FI��\�%T             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://dahvq5rjfsix6"
path="res://.godot/imported/rock_hover.png-cbbf8103cfe76da35d723fe0523bc71b.ctex"
metadata={
"vram_texture": false
}
          GST2            ����                        �   RIFF�   WEBPVP8L~   /� 7`$ ����j���d�ϥ�A����K���lB� ����y)j�M#I�>��R��u���o�~�1���s��:����L�"$ #\@(S��`(�R	�@�B��J��S�1'      [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://kt46fkd53vqj"
path="res://.godot/imported/rock_normal.png-f8d384df26a19dc8d2ec63b8770710b7.ctex"
metadata={
"vram_texture": false
}
          GST2            ����                        �   RIFF�   WEBPVP8L~   /� 7�  FdU;� �	���� &���	a� 扶�k��,�H�۸R�� R �8���s�W0���O��Uq�jSm�\�r�+@P. ��?�
��@�J)%j��jV��       [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bwcy5ovuqlksp"
path="res://.godot/imported/rock_pressed.png-b678799f20d8576c71edf83d47bff938.ctex"
metadata={
"vram_texture": false
}
        class_name RPSM


var _tactic_weight = 0.7
var _previous_throw = 0
var _previous_result = 2
var _previous_tactic_is_second = false
var _random_generator = RandomNumberGenerator.new()


func adapt(last_result : int):
	if _previous_result != 2 && last_result != 2:
		var addition = 0.2 * last_result
		if _previous_tactic_is_second: addition = -addition
		_tactic_weight = clampf(_tactic_weight + addition, 0.1, 0.9)
	_previous_result = last_result


func throw() -> int:
	var generated_value = _random_generator.randf()
	if _previous_result == 2:
		if generated_value < 0.31:
			_previous_throw = 1
		elif generated_value < 0.31+0.33:
			_previous_throw = 0
		else:
			_previous_throw = 2
		return _previous_throw
	_previous_tactic_is_second = generated_value > _tactic_weight
	
	if _previous_result == 1:
		if _previous_tactic_is_second:
			_previous_throw = _previous_throw           #CS
		else:
			_previous_throw = (_previous_throw + 2) % 3 #CB
		return _previous_throw
		
	elif _previous_result == 0:
		if _previous_tactic_is_second:
			_previous_throw = (_previous_throw + 2) % 3 #CB
		else:
			_previous_throw = (_previous_throw + 1) % 3 #CF
		return _previous_throw
		
	else:
		if _previous_tactic_is_second:
			_previous_throw = (_previous_throw + 1) % 3 #CF
		else:
			_previous_throw = (_previous_throw + 2) % 3 #CB
		return _previous_throw
         GST2            ����                        �   RIFF�   WEBPVP8L�   /� G@&���?ٌf�,
![��������� ��L���/|����� ��ؾ�j�;�Ǎ$)RK��=6��:2`��CFk}����n"�?ck�љ] p�d���j�;�Qy�Ghw�6o��f�ߛF�HD��zR2�@
�q�4����& ���s.w�uck�         [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://o0xx0y63nfno"
path="res://.godot/imported/scissors_hover.png-ad5acfed88db0c0386d2b362a3317657.ctex"
metadata={
"vram_texture": false
}
       GST2            ����                        �   RIFF�   WEBPVP8L�   /� ?@$@��->���>!�����	X`3���SIi�
� ��ʾ�ʘ$18nm���DZ3��/]
0L*�������{���lSq(�xd�p��ϳx����߈�0�}?�;��{�3s�z�]V+�(� �V*Y%��J�B�B�
����         [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://u2nktykygi1r"
path="res://.godot/imported/scissors_normal.png-d9f1932440b74fc2ccd74aab6ed3cb54.ctex"
metadata={
"vram_texture": false
}
      GST2            ����                        �   RIFF�   WEBPVP8L�   /� ?��m�׻�pP
GA$����|-�0�����Wԁ� ����v8nm���DZ3��/]
0L*�������{���lSq(�xd�p��ϳx����߈�0�}?�;��{�3s�z�]V+�(� �V*Y%��J�B�B�
����     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://c05b4xi2cqhna"
path="res://.godot/imported/scissors_pressed.png-4e98f532ca9c22bfd9872e77dd4c033a.ctex"
metadata={
"vram_texture": false
}
    GST2            ����                        |   RIFFt   WEBPVP8Lg   /�   :�O�!KH@xh�5�����ܓE'�?� E�"�v2���y�Qf��$�s�"�C]�SFV�X�u��\�
��U���X�E�"~xⓀq��z             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://70nufqpkmkhx"
path="res://.godot/imported/unknown_choice.png-1af4bef2da7ccfc91f2c676c9f934fec.ctex"
metadata={
"vram_texture": false
}
       [remap]

path="res://.godot/exported/133200997/export-75187f5b8f76bb0bea9ac8c296bdda67-gameplay.scn"
           [remap]

path="res://.godot/exported/133200997/export-2bc2da292bf5f8577c1a793715b24012-minecraft.res"
          list=Array[Dictionary]([{
"base": &"RefCounted",
"class": &"RPSM",
"icon": "",
"language": &"GDScript",
"path": "res://rpsm.gd"
}])
               -����O   res://gameplay.tscnxaJed   res://minecraft.tres(0��I   res://minecraft_font.ttf��E�l   res://paper_hover.png�5��P�   res://paper_normal.png�I�+E'�'   res://paper_pressed.png�#�<�Ȓc   res://rock_hover.pngf8�iO
   res://rock_normal.png3��/?�6   res://rock_pressed.pngdI���_   res://scissors_hover.pngOT�JD   res://scissors_normal.png�Gп�r[   res://scissors_pressed.png�q�wY��   res://unknown_choice.png             ECFG	      application/config/name         Product    application/run/main_scene         res://gameplay.tscn    application/config/features(   "         4.2    GL Compatibility    "   display/window/size/viewport_width      X  #   display/window/size/viewport_height      �     display/window/stretch/mode         canvas_items9   rendering/textures/canvas_textures/default_texture_filter         #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility              