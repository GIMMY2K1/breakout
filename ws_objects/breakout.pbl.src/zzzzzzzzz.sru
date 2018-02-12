$PBExportHeader$zzzzzzzzz.sru
forward
global type zzzzzzzzz from nonvisualobject
end type
end forward

global type zzzzzzzzz from nonvisualobject
end type
global zzzzzzzzz zzzzzzzzz

on zzzzzzzzz.create
call super::create
TriggerEvent( this, "constructor" )
end on

on zzzzzzzzz.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

