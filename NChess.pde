boolean showCoords = false;
JSONObject pBoard;
JSONObject sBoard;
int n = 2;
int player = 0;
PShape[] gPiece;
String selected = "";
int beginAnimation = 0;
String lastPlay = "Set Up";
boolean inPromotion = false;
JSONObject save;
JSONObject config;
String  saveName;
boolean notStarted = true;
boolean playerRotate = false;
boolean webPlay = false;
LogPopUp logPopUp;

void setup() {
  try {
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  }
  catch (UnsupportedLookAndFeelException e) {
  }
  catch (ClassNotFoundException e) {
  }
  catch (InstantiationException e) {
  }
  catch (IllegalAccessException e) {
  }
  StartPopUp popup = new StartPopUp(this);
  size(800, 800);
  colorMode(HSB);
  textAlign(CENTER);
  shapeMode(CENTER);
  gPiece = new PShape[6];
  gPiece[0]=loadShape("P.svg");
  gPiece[1]=loadShape("R.svg");
  gPiece[2]=loadShape("N.svg");
  gPiece[3]=loadShape("B.svg");
  gPiece[4]=loadShape("Q.svg");
  gPiece[5]=loadShape("K.svg");
  gPiece[0].disableStyle();
  gPiece[1].disableStyle();
  gPiece[2].disableStyle();
  gPiece[3].disableStyle();
  gPiece[4].disableStyle();
  gPiece[5].disableStyle();
  saveName = Long.toString(System.currentTimeMillis(), 36).toUpperCase();
}

void buildBoard() {
  buildMenuBar();
  sBoard = new JSONObject();
  if (args != null && args[0].endsWith(".ncs")) {    //Loaded Game
    save = loadJSONObject(args[0]);
    pBoard = save.getJSONObject("pBoard");
    n = save.getInt("players");
    player = save.getInt("currentPlayer");
    saveName = save.getString("name");
  } else {                                          //New Game
    player = 0;
    pBoard = new JSONObject();
    save = new JSONObject();
    save.setJSONArray("log", new JSONArray());
    save.setInt("players", n);
    save.setInt("currentPlayer", player);
    save.setString("name", saveName);
    for (int a = 1; a < n+1; a++) {
      for (int b = 0; b < 8; b++) {
        for (int c = 1; c < 4+1; c++) {
          if (c == 1) {
            if (b == 0 || b == 7) {
              pBoard.setString(a+""+(char)(b+'a')+""+c, a+"Ri");
            } else if (b == 1 || b == 6) {
              pBoard.setString(a+""+(char)(b+'a')+""+c, a+"N");
            } else if (b == 2 || b == 5) {
              pBoard.setString(a+""+(char)(b+'a')+""+c, a+"B");
            } else if (b == 3) {                                  //((a%2 == 0)? b == 4 : b == 3) {
              pBoard.setString(a+""+(char)(b+'a')+""+c, a+"Q");
            } else if (b == 4) {                                  //((a%2 == 0)? b == 3 : b == 4) {
              pBoard.setString(a+""+(char)(b+'a')+""+c, a+"Ki");
            }
          } else if (c == 2) {
            pBoard.setString(a+""+(char)(b+'a')+""+c, a+"p");
          } else {
            pBoard.setString(a+""+(char)(b+'a')+""+c, "");
          }
        }
      }
    }
    save.setJSONObject("pBoard", pBoard);
  }
  ((processing.awt.PSurfaceAWT.SmoothCanvas)this.getSurface().getNative()).getFrame().setTitle("NChess - " + (webPlay?"@":"") + saveName);
}

void draw() {
  if (notStarted) return;
  PVector mouse = new PVector(mouseX, mouseY);
  translate(width/2, height/2);
  background(127);
  Board(n, width/3.8);
  resetMatrix();
  fill(color(map(player%n, 0, n, 0, 255), 255, 255));
  rect(0, 0, 50, 50);
  for (Object o : pBoard.keys()) {
    String b = o.toString();
    if (!pBoard.get(b).equals("")) {
      PVector pos = new PVector(int(sBoard.getString(b).split("/")[0]), int(sBoard.getString(b).split("/")[1]));
      fill((b == selected) ? 127 : color(map(side(pBoard.getString(b)) - '1', 0, n, 0, 255), 255, 255));
      stroke((PVector.dist(pos, mouse) < 15) ? 0 : 127);
      if (piece(pBoard.getString(b)) == 'p' || piece(pBoard.getString(b)) == 'P') {
        shape(gPiece[0], pos.x, pos.y);
      } else if (piece(pBoard.getString(b)) == 'R') {
        shape(gPiece[1], pos.x, pos.y);
      } else if (piece(pBoard.getString(b)) == 'N') {
        shape(gPiece[2], pos.x, pos.y);
      } else if (piece(pBoard.getString(b)) == 'B') {
        shape(gPiece[3], pos.x, pos.y);
      } else if (piece(pBoard.getString(b)) == 'Q') {
        shape(gPiece[4], pos.x, pos.y);
      } else if (piece(pBoard.getString(b)) == 'K') {
        shape(gPiece[5], pos.x, pos.y);
      }
    }
  }
  if (pBoard.hasKey(selected) && !pBoard.get(selected).equals("")) {
    showHint();
  }
  if (showCoords) {
    for (Object o : pBoard.keys()) {
      String b = o.toString();
      fill(127);
      text(b, int(sBoard.getString(b).split("/")[0]), int(sBoard.getString(b).split("/")[1]));
    }
  }
  if (inPromotion) {
    stroke(0);
    fill(127);
    rect(width/2-50, height/2-50, 100, 100);
    fill(color(map(side(pBoard.getString(selected)) - '1', 0, n, 0, 255), 255, 255));
    shape(gPiece[1], width/2-25, height/2-25);
    shape(gPiece[2], width/2+25, height/2-25);
    shape(gPiece[3], width/2-25, height/2+25);
    shape(gPiece[4], width/2+25, height/2+25);
  }
  if (xeque((char)(player%n + '1'))) {
    fill(0);
    rect(0, 0, 50, 50);
    fill(255);
    text("Xeque", 75, 75);
  }
}

void Board(int p, float s) {
  sBoard = new JSONObject();
  if (playerRotate) {
    rotate(PI/p + PI/p * player * 2);
    if (beginAnimation != 0) {
      rotate(PI/p/15*(frameCount - beginAnimation));
      sBoard = new JSONObject();
      if (beginAnimation + 30 == frameCount) {
        player++;
        beginAnimation = 0;
      }
    }
  } else {
    rotate(PI/p);
    if (beginAnimation != 0) {
      sBoard = new JSONObject();
      if (beginAnimation + 3 == frameCount) {
        player++;
        beginAnimation = 0;
      }
    }
  }
  for (int i = 0; i < p*2; i++) {
    Quarter(s, PI/p, (i%2==0), i, p);
    rotate(-PI/p);
  }
}

void Quarter(float r, float d, boolean b, int c, int p)
{
  pushMatrix();
  float a = HALF_PI - d;
  for (int i = 0; i<4; i++) {
    for (int j = 0; j<4; j++) {
      String id = (((c%2==0) ? c/2 : (c-1)/2) + 1) + "" + (char)(((c%2==0) ? 3-j : 4+i) + 'a') + "" + (4 - ((c%2==0) ? i : j));
      float y = j*r/4;
      float x = 0;
      if ((i+j)%2 == 0)
        fill(b ? color(map(round(c/2), 0, p, 0, 255), 255, 15) : color(map(round(c/2), 0, p, 0, 255), 75, 255));
      else
        fill(b ? color(map(round(c/2), 0, p, 0, 255), 75, 200) : color(map(round(c/2), 0, p, 0, 255), 255, 75));
      noStroke();
      beginShape();
      vertex(x, y);
      vertex(x+r/4*cos(a), y+r/4*sin(a));
      vertex(x+r/4*cos(a), y+r/4+r/4*sin(a));
      vertex(x, y+r/4);
      endShape(CLOSE);
      if (!sBoard.hasKey(id)) {
        PVector pos = new PVector(x, y).lerp(new PVector(x+r/4*cos(a), y+r/4+r/4*sin(a)), 0.5);
        sBoard.setString(id, (int)screenX(pos.x, pos.y) + "/" + (int)screenY(pos.x, pos.y));
      }
      if (j==3) {
        translate(r/4*cos(a), r/4*sin(a));
      }
    }
  }
  popMatrix();
}

void showHint() {
  pushStyle();
  strokeWeight(2);
  stroke(255);
  noFill();
  blendMode(DIFFERENCE);
  for (Object o : pBoard.keys()) {
    String b = o.toString();
    PVector pos = new PVector(int(sBoard.getString(b).split("/")[0]), int(sBoard.getString(b).split("/")[1]));
    if (validity(b)) {
      switch(piece(pBoard.getString(selected))) {
      case 'P':
      case 'p':
        shape(gPiece[0], pos.x, pos.y);
        break;
      case 'R':
        shape(gPiece[1], pos.x, pos.y);
        break;
      case 'N':
        shape(gPiece[2], pos.x, pos.y);
        break;
      case 'B':
        shape(gPiece[3], pos.x, pos.y);
        break;
      case 'Q':
        shape(gPiece[4], pos.x, pos.y);
        break;
      case 'K':
        shape(gPiece[5], pos.x, pos.y);
        break;
      }
    }
  }
  popStyle();
}

boolean validity(String to) {
  return validity(selected, to);
}

boolean validity(String from, String to) {
  if (
    from != to &&
    pBoard.hasKey(from) && !pBoard.get(from).equals("") &&
    (pBoard.getString(to).equals("") || army(pBoard.getString(to)) != army(pBoard.getString(from))) &&
    (army(pBoard.getString(from)) - '1') % n == player % n
    ) {
    StringList list = new StringList();
    switch(piece(pBoard.getString(from))) {
    case 'p':
      if (flag(pBoard.getString(from)) == 'e') {
        recursive(list, from, Dir.E, Opt.CAPTURE_ONLY);
        recursive(list, from, Dir.W, Opt.CAPTURE_ONLY);
      }
      if (army(pBoard.getString(from)) == side(from)) {
        recursive(list, from, Dir.NW, Opt.CAPTURE_ONLY);
        recursive(list, from, Dir.NE, Opt.CAPTURE_ONLY);
        list = reduce(list, from, 1);
        recursive(list, from, Dir.N, Opt.WALK_ONLY);
      } else {
        recursive(list, from, Dir.SW, Opt.CAPTURE_ONLY);
        recursive(list, from, Dir.SE, Opt.CAPTURE_ONLY);
        list = reduce(list, from, 1);
        recursive(list, from, Dir.S, Opt.WALK_ONLY);
      }
      return reduce(list, from, (level(from) == '2') ? 2 : 1).hasValue(to);
    case 'R':
      recursive(list, from, Dir.N);
      recursive(list, from, Dir.S);
      recursive(list, from, Dir.E);
      recursive(list, from, Dir.W);
      return list.hasValue(to);
    case 'N':
      recursive(list, from, Dir.N, Opt.JUMP);
      recursive(list, from, Dir.S, Opt.JUMP);
      recursive(list, from, Dir.E, Opt.JUMP);
      recursive(list, from, Dir.W, Opt.JUMP);
      recursive(list, from, Dir.NE, Opt.JUMP);
      recursive(list, from, Dir.SE, Opt.JUMP);
      recursive(list, from, Dir.SW, Opt.JUMP);
      recursive(list, from, Dir.NW, Opt.JUMP);
      return reduce(invert(list), from, 2).hasValue(to);
    case 'B':
      recursive(list, from, Dir.NE);
      recursive(list, from, Dir.SE);
      recursive(list, from, Dir.SW);
      recursive(list, from, Dir.NW);
      return list.hasValue(to);
    case 'Q':
      recursive(list, from, Dir.N);
      recursive(list, from, Dir.S);
      recursive(list, from, Dir.E);
      recursive(list, from, Dir.W);
      recursive(list, from, Dir.NE);
      recursive(list, from, Dir.SE);
      recursive(list, from, Dir.SW);
      recursive(list, from, Dir.NW);
      return list.hasValue(to);
    case 'K':
      recursive(list, from, Dir.N);
      recursive(list, from, Dir.S);
      recursive(list, from, Dir.E);
      recursive(list, from, Dir.W);
      recursive(list, from, Dir.NE);
      recursive(list, from, Dir.SE);
      recursive(list, from, Dir.SW);
      recursive(list, from, Dir.NW);
      list = reduce(list, from, 1);
      if (flag(pBoard.getString(from)) == 'i') { // Se o rei não foi movido
        if (pBoard.getString((char)army(pBoard.getString(from)) + "f1").equals("") && pBoard.getString((char)army(pBoard.getString(from)) + "g1").equals("") && flag(pBoard.getString((char)army(pBoard.getString(from)) + "h1")) == 'i') {
          list.append((char)army(pBoard.getString(from)) + "g1");
        } else if (pBoard.getString((char)army(pBoard.getString(from)) + "b1").equals("") && pBoard.getString((char)army(pBoard.getString(from)) + "c1").equals("") && pBoard.getString((char)army(pBoard.getString(from)) + "d1").equals("") && flag(pBoard.getString((char)army(pBoard.getString(from)) + "a1")) == 'i') {
          list.append((char)army(pBoard.getString(from)) + "c1");
        }
      }
      return list.hasValue(to);
    default:
      return false;
    }
  }
  return false;
}

char transverse(char c) {
  return (char)('h' - c + 'a');
}

char side(String Square) {
  return Square.charAt(0);
}

char letter(String Square) {
  return Square.charAt(1);
}

char level(String Square) {
  return Square.charAt(2);
}

char army(String Piece) {
  return Piece.charAt(0);
}

char piece(String Piece) {
  return Piece.charAt(1);
}

char flag(String Piece) {
  if (Piece.length() > 2)
    return Piece.charAt(2);
  else return 0;
}

enum Dir {
  N, S, E, W, NE, SE, SW, NW
}

enum Opt {
  WALK_CAPTURE, WALK_ONLY, CAPTURE_ONLY, JUMP
}

void recursive(StringList rec, String origin, Dir d) {
  recursive(rec, origin, origin, d, Opt.WALK_CAPTURE);
}

void recursive(StringList rec, String origin, Dir d, Opt o) {
  recursive(rec, origin, origin, d, o);
}

void recursive(StringList rec, String origin, String square, Dir d, Opt o) {
  if (
    square == origin ||
    o != Opt.WALK_ONLY ||
    (o == Opt.WALK_ONLY && pBoard.get(square).equals(""))
    ) {
    if (
      square == origin ||
      o != Opt.CAPTURE_ONLY ||
      (o == Opt.CAPTURE_ONLY && !pBoard.get(square).equals(""))
      ) {
      if (
        square == origin ||                                                                                      // Quadrado inicial
        o == Opt.JUMP ||                                                                                         // Ignora peças
        (pBoard.get(square).equals("") ||                                                                        // Quadrado Vazio
        (!pBoard.get(square).equals("") && army(pBoard.getString(origin)) != army(pBoard.getString(square))))    // Para antes da própria peça
        )
      {
        switch(d) {
        case N:
          if (level(square) == '1' && side(origin) != side(square) || (o != Opt.JUMP && !pBoard.getString(square).equals("") && army(pBoard.getString(origin)) != army(pBoard.getString(square)))) {
            rec.append(square);
            break;
          } else if (level(square) != '4') {
            rec.append(square);
            recursive(rec, origin, next(square, d), d, o);
            break;
          } else if (level(square) == '4') {
            rec.append(square);
            for (int s = 0; s < n; s++) {
              if ((char)side(origin) != s + '1') {
                recursive(rec, origin, next(square, s, d), Dir.S, o);
              }
            }
            break;
          }
          break;
        case S:
          if (level(square) == '1' && side(origin) == side(square) || (o != Opt.JUMP && !pBoard.getString(square).equals("") && army(pBoard.getString(origin)) != army(pBoard.getString(square)))) {
            rec.append(square);
            break;
          } else {
            rec.append(square);
            if (level(square) != '1')
              recursive(rec, origin, next(square, d), d, o);
            break;
          }
        case E:
          if (letter(square) == 'h' || (o != Opt.JUMP && !pBoard.getString(square).equals("") && army(pBoard.getString(origin)) != army(pBoard.getString(square)))) {
            rec.append(square);
            break;
          } else {
            rec.append(square);
            recursive(rec, origin, next(square, d), d, o);
            break;
          }
        case W:
          if (letter(square) == 'a' || (o != Opt.JUMP && !pBoard.getString(square).equals("") && army(pBoard.getString(origin)) != army(pBoard.getString(square)))) {
            rec.append(square);
            break;
          } else {
            rec.append(square);
            recursive(rec, origin, next(square, d), d, o);
            break;
          }
        case NE:
          if (level(square) == '1' && side(origin) != side(square) || letter(square) == 'h' || (o != Opt.JUMP && !pBoard.getString(square).equals("") && army(pBoard.getString(origin)) != army(pBoard.getString(square)))) {
            rec.append(square);
            break;
          } else if (level(square) != '4') {
            rec.append(square);
            recursive(rec, origin, next(square, d), d, o);
            break;
          } else if (level(square) == '4') {
            rec.append(square);
            for (int s = 0; s < n; s++) {
              if ((char)side(origin) != s + '1') {
                recursive(rec, origin, next(square, s, d), Dir.SW, o);
              }
            }
            break;
          }
          break;
        case NW:
          if (level(square) == '1' && side(origin) != side(square) || letter(square) == 'a' || (o != Opt.JUMP && !pBoard.getString(square).equals("") && army(pBoard.getString(origin)) != army(pBoard.getString(square)))) {
            rec.append(square);
            break;
          } else if (level(square) != '4') {
            rec.append(square);
            recursive(rec, origin, next(square, d), d, o);
            break;
          } else if (level(square) == '4') {
            rec.append(square);
            for (int s = 0; s < n; s++) {
              if ((char)side(origin) != s + '1') {
                recursive(rec, origin, next(square, s, d), Dir.SE, o);
              }
            }
            break;
          }
          break;
        case SE:
          if (level(square) == '1' && side(origin) == side(square) || letter(square) == 'h' || (o != Opt.JUMP && !pBoard.getString(square).equals("") && army(pBoard.getString(origin)) != army(pBoard.getString(square)))) {
            rec.append(square);
            break;
          } else {
            rec.append(square);
            if (level(square) != '1')
              recursive(rec, origin, next(square, d), d, o);
            break;
          }
        case SW:
          if (level(square) == '1' && side(origin) == side(square) || letter(square) == 'a' || (o != Opt.JUMP && !pBoard.getString(square).equals("") && army(pBoard.getString(origin)) != army(pBoard.getString(square)))) {
            rec.append(square);
            break;
          } else {
            rec.append(square);
            if (level(square) != '1')
              recursive(rec, origin, next(square, d), d, o);
            break;
          }
        default:
          break;
        }
      }
    }
  }
}

String next(String square, Dir d) {
  return next(square, -1, d);
}

String next(String square, int side, Dir d) {
  switch(d) {
  case N:
    if (level(square) != '4') {
      return (char)side(square) + "" + (char)letter(square) + "" + (char)(level(square) + 1);
    } else if (level(square) == '4' && side != -1) {
      return (char)(side + '1') + "" + (char)transverse(letter(square)) + "" + (char)(level(square));
    }
    break;
  case S:
    if (level(square) != '1')
      return (char)side(square) + "" + (char)letter(square) + "" + (char)(level(square) - 1);
    break;
  case E:
    if (letter(square) != 'h')
      return (char)side(square) + "" + (char)(letter(square) + 1) + "" + (char)level(square);
    break;
  case W:
    if (letter(square) != 'a')
      return (char)side(square) + "" + (char)(letter(square) - 1) + "" + (char)level(square);
    break;
  case NE:
    if (level(square) != '4') {
      return next(next(square, side, Dir.N), Dir.E);
    } else if (level(square) == '4' && side != -1) {
      return next(next(square, side, Dir.N), Dir.W);
    }
    break;
  case NW:
    if (level(square) != '4') {
      return next(next(square, side, Dir.N), Dir.W);
    } else if (level(square) == '4' && side != -1) {
      return next(next(square, side, Dir.N), Dir.E);
    }
    break;
  case SE:
    return next(next(square, Dir.S), Dir.E);
  case SW:
    return next(next(square, Dir.S), Dir.W);
  default:
    return square;
  }
  return square;
}

StringList reduce(StringList list, String origin, int r) {
  StringList result = new StringList();
  String cheatList = "12348765";
  for (String s : list) {
    if ((side(s) == side(origin) && (letter(s) >= letter(origin) - r && letter(s) <= letter(origin) + r)) ||
      (side(s) != side(origin) && (transverse(letter(s)) >= letter(origin) - r && transverse(letter(s)) <= letter(origin) + r))) {
      if (abs(cheatList.indexOf(level(origin)) - cheatList.indexOf(level(s) + ((side(s) != side(origin))?4:0))) <= r)
        result.append(s);
    }
  }
  return result;
}

StringList invert(StringList list) {
  StringList result = new StringList();
  for (Object o : pBoard.keys()) {
    String s = o.toString();
    if (!list.hasValue(s)) {
      result.append(s);
    }
  }
  return result;
}

boolean xeque(char side) {
  for (Object o : pBoard.keys()) {
    String k = o.toString();
    if (!pBoard.get(k).equals("") && army(pBoard.getString(k)) == side && piece(pBoard.getString(k)) == 'K') {
      for (Object p : pBoard.keys()) {
        String b = p.toString();
        if (!pBoard.get(b).equals("") && validity(b, k)) {
          Log("XEQUE "+(char)side);
          return true;
        }
      }
    }
  }
  return false;
}

void mousePressed() {
  if (notStarted) return;
  String last = selected;
  PVector mouse = new PVector(mouseX, mouseY);
  if (inPromotion) {
    if (PVector.dist(new PVector(width/2-25, height/2-25), mouse) < 20) {
      pBoard.setString(selected, (char)army(pBoard.getString(selected)) + "R");
      lastPlay += "R";
    } else
      if (PVector.dist(new PVector(width/2+25, height/2-25), mouse) < 20) {
        pBoard.setString(selected, (char)army(pBoard.getString(selected)) + "N");
        lastPlay += "N";
      } else
        if (PVector.dist(new PVector(width/2-25, height/2+25), mouse) < 20) {
          pBoard.setString(selected, (char)army(pBoard.getString(selected)) + "B");
          lastPlay += "B";
        } else
          if (PVector.dist(new PVector(width/2+25, height/2+25), mouse) < 20) {
            pBoard.setString(selected, (char)army(pBoard.getString(selected)) + "Q");
            lastPlay += "Q";
          }
    if (piece(pBoard.getString(selected)) != 'p') {
      inPromotion = false;
      selected = "";
      beginAnimation = frameCount;
      Log(lastPlay);
      Save();
    }
  } else {
    for (Object o : pBoard.keys()) {
      String b = o.toString();
      PVector pos = new PVector(int(sBoard.getString(b).split("/")[0]), int(sBoard.getString(b).split("/")[1]));
      if (PVector.dist(pos, mouse) < 20) {
        selected = b;
        if (validity(last, selected)) {
          lastPlay = pBoard.getString(last).charAt(1) + last + " → " + ((!pBoard.getString(selected).equals("")) ? pBoard.getString(selected).charAt(1): "") + selected;
          if ((army(pBoard.getString(last))-1)%n == player%n && piece(pBoard.getString(last)) == 'K' && flag(pBoard.getString(last)) == 'i' && letter(selected) == 'g') { // Pq. Roque
            pBoard.setString((char)army(pBoard.getString(last)) + "f1", (char)army(pBoard.getString(last)) + "R");
            pBoard.setString((char)army(pBoard.getString(last)) + "h1", "");
            lastPlay = "O-O";
          }
          if ((army(pBoard.getString(last))-1)%n == player%n && piece(pBoard.getString(last)) == 'K' && flag(pBoard.getString(last)) == 'i' && letter(selected) == 'c') { // Gd. Roque
            pBoard.setString((char)army(pBoard.getString(last)) + "d1", (char)army(pBoard.getString(last)) + "R");
            pBoard.setString((char)army(pBoard.getString(last)) + "a1", "");
            lastPlay = "O-O-O";
          }
          if (piece(pBoard.getString(last)) == 'p' && level(last) == '2' && level(selected) == '4')
            pBoard.setString(last, pBoard.getString(last) + "e");
          if (flag(pBoard.getString(last)) == 'e' && level(last) == '4' || flag(pBoard.getString(last)) == 'i')
            pBoard.setString(last, pBoard.getString(last).substring(0, 2));
          pBoard.setString(selected, pBoard.getString(last));
          pBoard.setString(last, "");
          if (piece(pBoard.getString(selected)) == 'p' && level(selected) == '1') {
            inPromotion = true;
          } else {
            selected = "";
            beginAnimation = frameCount;
          }
          if (!inPromotion) {
            Log(lastPlay);
            Save();
          }
        }
        break;
      } else {
        selected = "";
      }
    }
  }
}

void Log(String log) {
  save.setJSONArray("log", save.getJSONArray("log").append(log));
  save.setJSONObject("pBoard", pBoard);
  save.setInt("currentPlayer", player+1);
  if (logPopUp != null)
    logPopUp.update();
  println(log);
}

void Save() {
  if (webPlay) post(false);
  saveJSONObject(save, "Saves/" + (webPlay?"@":"") + saveName + ".ncs");
  saveStrings("Logs/" + (webPlay?"@":"") + saveName + ".log", save.getJSONArray("log").getStringArray());
}
