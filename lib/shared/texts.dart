import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/////////////////////
/*    TEXT WHITE   */
/////////////////////
Text textWhite(String text) { return Text(text, style: GoogleFonts.lato(color: WHITE)); }
Text text13White(String text) { return Text(text, style: GoogleFonts.lato(fontSize: 13, color: WHITE)); }
Text text15White(String text) { return Text(text, style: GoogleFonts.lato(fontSize: 15, color: WHITE)); }
Text text16White(String text) { return Text(text, style: GoogleFonts.lato(fontSize: 16, color: WHITE)); }
Text text18White(String text) { return Text(text, style: GoogleFonts.lato(fontSize: 18, color: WHITE)); }
Text text20White(String text) { return Text(text, style: GoogleFonts.lato(fontSize: 20, color: WHITE)); }


/////////////////////
/* TEXT WHITE BOLD */
/////////////////////
Text textWhiteBold(String text) { return Text(text, style: GoogleFonts.lato(color: WHITE, fontWeight: FontWeight.bold)); }
Text text18WhiteBold(String text) { return Text(text, style: GoogleFonts.lato(fontSize: 18, color: WHITE, fontWeight: FontWeight.bold)); }
Text text20WhiteBold(String text) { return Text(text, style: GoogleFonts.lato(fontSize: 20, color: WHITE, fontWeight: FontWeight.bold)); }
Text text25WhiteBold(String text) { return Text(text, style: GoogleFonts.lato(fontSize: 25, color: WHITE, fontWeight: FontWeight.bold)); }


////////////////////////////////////
/*TEXT CENTER WHITE BOLD UNDERLINE*/
////////////////////////////////////
Text textCenter20WhiteBoldUnderline(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 20, color: WHITE, decoration: TextDecoration.underline, fontWeight: FontWeight.bold)); }
Text textWhiteBoldUnderline(String text) { return Text(text, style: GoogleFonts.lato(color: WHITE, decoration: TextDecoration.underline, fontWeight: FontWeight.bold)); }


/////////////////////
/*TEXT CENTER WHITE*/
/////////////////////
Text textCenterWhite(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(color: WHITE)); }
Text textCenter13White(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 13, color: WHITE)); }
Text textCenter14White(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 14, color: WHITE)); }
Text textCenter16White(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 16, color: WHITE)); }
Text textCenter18White(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 18, color: WHITE)); }
Text textCenter19White(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 19, color: WHITE)); }
Text textCenter20White(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 20, color: WHITE)); }
Text textCenter28White(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 28, color: WHITE)); }
Text textCenter30White(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 30, color: WHITE)); }


//////////////////////////
/*TEXT CENTER WHITE BOLD*/
/////////////////////////
Text textCenter20WhiteBold(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 20, color: WHITE, fontWeight: FontWeight.bold)); }


/////////////////////
/*    TEXT DARK    */
/////////////////////
Text text25Dark(String text) { return Text(text, style: GoogleFonts.lato(fontSize: 25, color: DARK)); }


/////////////////////
/*    TEXT GREEN   */
/////////////////////
Text textGreen(String text) { return Text(text, style: GoogleFonts.lato(color: GREEN)); }


/////////////////////////////////
/* TEXT CENTER GREEN UNDERLINE */
/////////////////////////////////
Text text25GreenUnderline(String text) { return Text(text, style: GoogleFonts.lato(fontSize: 20, color: GREEN, decoration: TextDecoration.underline)); }


////////////////////////////
/*    TEXT CENTER GREEN   */
////////////////////////////
Text textCenter18Green(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 18, color: GREEN)); }
Text textCenter20Green(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 20, color: GREEN)); }


////////////////////////////
/* TEXT CENTER GREEN BOLD */
////////////////////////////
Text textCenter16GreenBold(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 16, color: GREEN, fontWeight: FontWeight.bold)); }
Text textCenter18GreenBold(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 18, color: GREEN, fontWeight: FontWeight.bold)); }
Text textCenter20GreenBold(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 20, color: GREEN, fontWeight: FontWeight.bold)); }
Text textCenter28GreenBold(String text) { return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 28, color: GREEN, fontWeight: FontWeight.bold)); }


/////////////////////
/* TEXT GREEN BOLD */
/////////////////////
Text textGreenBold(String text) { return Text(text, style: GoogleFonts.lato(color: GREEN, fontWeight: FontWeight.bold)); }
Text text18GreenBold(String text) { return Text(text, style: GoogleFonts.lato(fontSize: 18, color: GREEN, fontWeight: FontWeight.bold)); }
Text text20GreenBold(String text) { return Text(text, style: GoogleFonts.lato(fontSize: 20, color: GREEN, fontWeight: FontWeight.bold)); }


/////////////////////
/*     TEXT RED    */
/////////////////////
Text textRed(String text) { return Text(text, style: GoogleFonts.lato(color: Colors.red)); }
Text text13Red(String text) { return Text(text, style: GoogleFonts.lato(fontSize: 13, color: Colors.red)); }


/////////////////////
/*   TEXT ORANGE   */
/////////////////////
Text textOrange(String text) { return Text(text, style: GoogleFonts.lato(color: Colors.orange)); }
