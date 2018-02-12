$PBExportHeader$w_breakout.srw
forward
global type w_breakout from Window
end type
type st_3 from statictext within w_breakout
end type
type em_difficulty from editmask within w_breakout
end type
type st_2 from statictext within w_breakout
end type
type cb_auto from commandbutton within w_breakout
end type
type st_score from statictext within w_breakout
end type
type st_1 from statictext within w_breakout
end type
type cb_1 from commandbutton within w_breakout
end type
type dw_1 from datawindow within w_breakout
end type
end forward

global type w_breakout from Window
int X=946
int Y=464
int Width=2807
int Height=2336
boolean TitleBar=true
string Title="BREAKOUT"
long BackColor=80269524
boolean ControlMenu=true
boolean Resizable=true
st_3 st_3
em_difficulty em_difficulty
st_2 st_2
cb_auto cb_auto
st_score st_score
st_1 st_1
cb_1 cb_1
dw_1 dw_1
end type
global w_breakout w_breakout

type variables
long il_sw=2, il_paddle[21], il_x, il_paddle_x
boolean ib_auto=FALSE
string is_breakout
long il_xx
end variables

forward prototypes
public subroutine wf_close ()
end prototypes

public subroutine wf_close ();this.event post close()
end subroutine

on w_breakout.create
this.st_3=create st_3
this.em_difficulty=create em_difficulty
this.st_2=create st_2
this.cb_auto=create cb_auto
this.st_score=create st_score
this.st_1=create st_1
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.st_3,&
this.em_difficulty,&
this.st_2,&
this.cb_auto,&
this.st_score,&
this.st_1,&
this.cb_1,&
this.dw_1}
end on

on w_breakout.destroy
destroy(this.st_3)
destroy(this.em_difficulty)
destroy(this.st_2)
destroy(this.cb_auto)
destroy(this.st_score)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event closequery;IF il_sw = 1 THEN
	il_sw = 3
	return 1
ELSE
	return 0
END IF

end event

type st_3 from statictext within w_breakout
int X=1207
int Y=2128
int Width=800
int Height=72
boolean Enabled=false
string Text="1 - easiest / 5 - most difficult"
boolean FocusRectangle=false
long BackColor=80269524
int TextSize=-8
int Weight=400
string FaceName="Arial"
boolean Italic=true
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type em_difficulty from editmask within w_breakout
int X=1609
int Y=2020
int Width=169
int Height=96
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
string Mask="#"
boolean Spin=true
double Increment=1
string MinMax="1~~5"
string Text="1"
long BackColor=16777215
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_breakout
int X=1248
int Y=2032
int Width=347
int Height=76
boolean Enabled=false
string Text="Difficulty:"
boolean FocusRectangle=false
long BackColor=80269524
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_auto from commandbutton within w_breakout
int X=311
int Y=2032
int Width=544
int Height=92
int TabOrder=20
string Text="Auto Play On"
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;

IF this.text = 'Auto Play On' THEN
	this.text = 'Auto Play Off'
	ib_auto = TRUE
	dw_1.event oe_auto_play()
ELSE
	this.text = 'Auto Play On'
	ib_auto = FALSE
END IF

end event

type st_score from statictext within w_breakout
int X=2359
int Y=2024
int Width=347
int Height=92
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
string Text="0"
boolean FocusRectangle=false
long TextColor=65280
long BackColor=0
int TextSize=-12
int Weight=700
string FaceName="Arial"
boolean Italic=true
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_breakout
int X=2085
int Y=2032
int Width=256
int Height=76
boolean Enabled=false
string Text="Score:"
boolean FocusRectangle=false
long BackColor=80269524
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_1 from commandbutton within w_breakout
int X=27
int Y=2032
int Width=261
int Height=92
int TabOrder=40
string Text="Start"
boolean Default=true
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;long ll_row, ll_row2, ll_y_max, ll_x_max, ll_y, ll_yy, ll_row3, ll_row_1, ll_row_2, ll_row_0
long ll_array[18,21], ll_col, ll_col_l, ll_col_r, ll_col_l1, ll_col_r1, ll_score, ll_redraw_sw, ll_row_x
boolean lb_match
long ll_row_t, ll_mod, ll_mod2, ll_mod3, ll_col_l2, ll_col_r2

IF this.text = 'Stop' THEN
	il_sw = 2
	this.text = 'Start'
ELSE
	start:
	st_score.text = '0'
	ll_score = 0
	dw_1.dataobject = 'd_breakout'
	
	//Build a multidimsional array to simulate the box_vis column of the breakout datawindow
	//Its much faster to manipulate arrays then to manipulate datawindows so have the array do as
	//much as possible.  Put it here because each time you press 'Start' the game starts over.
	ll_array = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,&
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}

	//Set the maximum x and y values
	ll_y_max = (84 * dw_1.rowcount()) - 84
	ll_x_max = 2633
	ll_yy = ll_y_max
	
	il_sw = 1
	
	//Set the random initial starting position of the ball
	ll_col = Randomize(0)
	il_xx = rand(ll_x_max)
	dw_1.object.oval_1.visible = 1
	
	//Set the x and y intervals of the movement of the ball
	ll_y = -3
	il_x = 4
	dw_1.object.xx[1] = il_xx
	
	//Initialize the autoplay feature
	dw_1.event oe_auto_play()

	this.text = 'Stop'
END IF

//Because the actual ball object is really a rectangle you must approximate the position of the ball when it gets
//close to a blue brick.  This can be done much more elaborately and accurately using trigonometric functions.
//But since I took Calc I 3 times I decided not to persue it.  I will leave that as an exercise for one of you.

DO UNTIL il_sw > 1
	//The ball can be on two rows at the same time.  Calculate those rows for roughly the upper, middle and lower
	// part of the ball.
	ll_mod = MOD(ll_yy,84)
	ll_mod2 = MOD(ll_yy + 26,84)
	ll_mod3 = MOD(ll_yy + 38,84)
	ll_row_x = CEILING((ll_yy - 14) / 84)
	ll_row_0 = CEILING((ll_yy + 26) / 84)
	ll_row_1 = CEILING((ll_yy) / 84)
	ll_row_2 = CEILING((ll_yy + 38) / 84)
	//If the upper part is on row 0, game over
	IF ll_row_1 = 0 THEN
		il_sw = 2
		IF ib_auto THEN
			goto start  //This isnt an example of OO programming, OK
		ELSE
			messagebox('','******* YOU WIN *******')
			this.text = 'Start'
			EXIT
		END IF
	END IF
	//IF min x or max x is reached go the other way
	IF il_xx >= ll_x_max THEN
		il_x = -4
	ELSEIF il_xx <= 0 THEN
		il_x = 4
	END IF
	lb_match = FALSE

	IF ib_auto THEN
		//If on auto move the paddle
		IF il_xx > 125 AND il_xx < ll_x_max THEN
			il_paddle_x = il_xx - 125
			dw_1.object.paddle_x[23] = il_paddle_x
			dw_1.object.paddle_vis[23] = 1
		END IF
	END IF
		
	IF ll_row_1 <= 17 THEN
		//Different surfaces of the ball will contact different bricks.  For example does the top of the ball hit the
		//underside of a brick before the right side of the ball hit the left side of the brick?
		//This is approximated by determining which 'col' or 'brick' the left, right and middle parts of the ball are
		// based on its x value.  This is very crude as the 'ball' is really defined as a rectangle in PB
		//but its a fair approximation
		ll_col = CEILING((il_xx + 50) / 137)
		ll_col_l = CEILING((il_xx + 35) / 137)
		ll_col_r = CEILING((il_xx + 65) / 137)
		ll_col_l1 = CEILING((il_xx + 12) / 137)
		ll_col_r1 = CEILING((il_xx + 93) / 137)
		ll_col_l2 = CEILING((il_xx + 6) / 137)
		ll_col_r2 = CEILING((il_xx + 99) / 137)
		//Contact in the Y direction is checked first
		IF ll_y < 0 THEN
			IF ll_mod < 72 AND ll_mod > 0 THEN
			//The ball will only strike the underside of a brick while its going up
				IF ll_array[ll_row_1,ll_col] = 1 THEN
					lb_match = TRUE
					ll_y = 3
					goto here
				END IF
				IF ll_mod < 66 THEN
					IF ll_array[ll_row_1,ll_col_l] = 1 THEN
						ll_col = ll_col_l
						lb_match = TRUE
						ll_y = 3
						goto here
					END IF
					IF ll_array[ll_row_1,ll_col_r] = 1 THEN
						ll_col = ll_col_r
						lb_match = TRUE
						ll_y = 3
						goto here
					END IF
				END IF
			END IF
		ELSEIF ll_row_1 < 17 THEN
			//The ball will only strike the top of a brick while its going down
			IF ll_mod >= 16 THEN
				IF ll_array[ll_row_1 + 1,ll_col] = 1 THEN
					ll_row_1++
					lb_match = TRUE
					ll_y = -3
					goto here
				END IF
				IF ll_mod >= 22 THEN
					IF ll_array[ll_row_1 + 1,ll_col_l] = 1 THEN
						ll_row_1++
						ll_col = ll_col_l
						lb_match = TRUE
						ll_y = -3
						goto here
					END IF
					IF ll_array[ll_row_1+1,ll_col_r] = 1 THEN
						ll_row_1++
						ll_col = ll_col_r
						lb_match = TRUE
						ll_y = -3
						goto here
					END IF
				END IF
			END IF
		END IF

		//Now check for contact in the X direction
		IF il_x < 0 THEN
			IF ll_mod2 <= 52 THEN
				IF ll_array[ll_row_0,ll_col_l1] = 1 THEN
					ll_col = ll_col_l1
					ll_row_1 = ll_row_0
					lb_match = TRUE
					il_x = 4
					goto here
				END IF
			ELSEIF ll_mod2 <= 76 THEN
				IF ll_array[ll_row_2,ll_col_l2] = 1 THEN
					ll_col = ll_col_l2
					ll_row_1 = ll_row_2
					lb_match = TRUE
					il_x = 4
					goto here
				END IF
			END IF
		ELSE
			IF ll_mod2 <= 52 THEN
				IF ll_array[ll_row_0,ll_col_r1] = 1 THEN
					ll_col = ll_col_r1
					ll_row_1 = ll_row_0
					lb_match = TRUE
					il_x = -4
					goto here
				END IF
			ELSEIF ll_mod2 <= 76 THEN
				IF ll_array[ll_row_2,ll_col_r2] = 1 THEN
					ll_col = ll_col_r2
					ll_row_1 = ll_row_2
					lb_match = TRUE
					il_x = -4
					goto here
				END IF
			END IF
		END IF
	ELSEIF ll_row_x >= 22 and ll_y > 0 THEN
		//If the ball is on the last row check for the location of the paddle
		//To make the paddle more 'forgiving' you can adjust the boundries of a 'hit'
		//In this case its the 50 in the line below.  The higher the number the greater tolerance for miss hits.
		IF il_xx + 50 > il_paddle_x AND il_xx + 50 < il_paddle_x + 251 THEN
			//A hit.  If all the bricks from the last brick row are gone, move all bricks down a row
			//and add a row at the top
			IF dw_1.object.box_vis[17] = '00000000000000000000' THEN 
				dw_1.rowsdiscard(22,22,primary!)
				dw_1.rowscopy(1,1,primary!,dw_1,1,primary!)
				dw_1.object.yy[2] = 1
				dw_1.object.xx[2] = 1
				dw_1.object.color[1] = dw_1.object.color[5]
				//must refresh array
				FOR ll_row2 = 17 TO 1 STEP -1
					FOR ll_row3 = 1 TO 21
						ll_array[ll_row2+1,ll_row3] = ll_array[ll_row2,ll_row3]
					NEXT
				NEXT
			END IF
			ll_y = -3
		ELSE
			messagebox('','******* LOOOOSSSSEEER *******')
			il_sw = 2
			this.text = 'Start'
			return
		END IF
	END IF
	here:
	IF lb_match THEN
		//If there is a hit make the brick invisible and set the array value to 0
		ll_score = ll_score + 10
		st_score.text = STRING(ll_score)
		ll_array[ll_row_1,ll_col] = 0
		//Mustidimensional datawindow!!!
		dw_1.object.box_vis[ll_row_1] = REPLACE(dw_1.object.box_vis[ll_row_1],ll_col,1,'0')
		Beep(1)
	END IF
	IF keydown(keyrightarrow!) THEN
		//Move paddle right
		IF il_paddle_x < ll_x_max - 251 THEN
			il_paddle_x = il_paddle_x + 10
			dw_1.object.paddle_x[23] = il_paddle_x
			dw_1.object.paddle_vis[23] = 1
		END IF
	ELSEIF keydown(keyleftarrow!) THEN
		//Move paddle left
		IF il_paddle_x > 0 THEN
			il_paddle_x = il_paddle_x - 10
			dw_1.object.paddle_x[23] = il_paddle_x
			dw_1.object.paddle_vis[23] = 1
		END IF
	END IF
	//Move ball
	il_xx = il_xx + il_x
	ll_yy = ll_yy + ll_y
	dw_1.object.yy[1] = ll_yy
	dw_1.object.xx[1] = il_xx
	
	IF NOT ib_auto THEN
		ll_redraw_sw++
		//Use the setredraw to control the speed of play in the manual mode.  Notice how the setredraw function
		//affect performance
		IF ll_redraw_sw = LONG(em_difficulty.text) THEN
			dw_1.setredraw(TRUE)
			ll_redraw_sw = 0
		END IF
	END IF
	yield()
LOOP

//Close if you press close
IF il_sw = 3 THEN
	close(parent)
END IF
end event

event constructor;is_breakout = '1,1,84,65535,"11111111111111111111",0,0'+&
'1,1,84,255,"11111111111111111111",0,0'+&
'1,1,84,16776960,"11111111111111111111",0,0'+&
'1,1,84,16711680,"11111111111111111111",0,0'+&
'1,1,84,65535,"11111111111111111111",0,0'+&
'1,1,84,255,"11111111111111111111",0,0'+&
'1,1,84,16776960,"11111111111111111111",0,0'+&
'1,1,84,16711680,"11111111111111111111",0,0'+&
'1,1,84,65535,"11111111111111111111",0,0'+&
'1,1,84,255,"11111111111111111111",0,0'+&
'1,1,84,16776960,"11111111111111111111",0,0'+&
'1,1,84,16711680,"11111111111111111111",0,0'+&
'1,1,84,65535,"11111111111111111111",0,0'+&
'1,1,84,255,"11111111111111111111",0,0'+&
'1,1,84,16776960,"11111111111111111111",0,0'+&
'1,1,84,16711680,"11111111111111111111",0,0'+&
'1,1,84,65535,"11111111111111111111",0,0'+&
'1,1,84,255,"11111111111111111111",0,0'+&
'1,1,84,16776960,"11111111111111111111",0,0'+&
'1,1,84,16711680,"00000000000000000000",0,0'+&
'1,1,84,65535,"00000000000000000000",0,0'+&
'1,1,84,255,"00000000000000000000",0,0'+&
'1,1,84,16776960,"00000000000000000000",1,10'
end event

type dw_1 from datawindow within w_breakout
event oe_auto_play ( )
event oe_mm pbm_mousemove
event key pbm_dwnkey
int Y=8
int Width=2766
int Height=1956
int TabOrder=10
string DataObject="d_breakout"
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type

event oe_auto_play;il_paddle_x = il_xx - 125
dw_1.object.paddle_x[23] = il_paddle_x


//long ll_row, ll_xx, ll_col, ll_paddle[]
//IF dw_1.rowcount() > 0 THEN
//	ll_paddle = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
//	ll_xx = il_x
//	ll_row = CEILING(ll_yy / 84)
//	ll_col = dw_1.object.array_col[ll_row]
//
////	il_paddle_x = xpos - 125
////	this.object.paddle_x[23] = xpos - 125
//
//
//	IF ll_col > 1 THEN
//		IF il_x > 0 THEN
//			ll_paddle[ll_col - 1] = 1
//			ll_paddle[ll_col] = 1
//		ELSE
//			ll_paddle[ll_col] = 1
//			ll_paddle[ll_col+1] = 1
//		END IF
//	ELSE
//		ll_paddle[ll_col] = 1
//		ll_paddle[ll_col+1] = 1
//	END IF
//	il_paddle = ll_paddle
//	dw_1.object.paddle_x[23] = ll_col
//END IF
end event

event oe_mm;long ll_x

IF flags = 1 THEN
	il_paddle_x = xpos - 125
	this.object.paddle_x[23] =il_paddle_x
END IF

end event

event key;long ll_x, ll_difficulty

IF key = keyuparrow! THEN
	ll_difficulty = LONG(em_difficulty.text)
	IF ll_difficulty < 5 THEN
		em_difficulty.text = STRING(ll_difficulty + 1)
	END IF
ELSEIF key = keydownarrow! THEN
	ll_difficulty = LONG(em_difficulty.text)
	IF ll_difficulty > 1 THEN
		em_difficulty.text = STRING(ll_difficulty - 1)
	END IF
END IF

dw_1.setredraw(TRUE)
end event

