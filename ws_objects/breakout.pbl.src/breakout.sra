$PBExportHeader$breakout.sra
$PBExportComments$Generated Application Object
forward
global type breakout from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type breakout from application
string appname = "breakout"
end type
global breakout breakout

on breakout.create
appname="breakout"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on breakout.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_breakout)
end event

