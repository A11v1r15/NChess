boolean showCoords = false; //<>//
StringDict pBoard;
StringDict sBoard;
int n = 3;
int player = 0;
PShape[] gPiece;
String selected = "";
boolean fullPortal = false;
int beginAnimation = 0;
String lastPlay = "Set Up";
boolean inPromotion = false;
String rollUp = "";

void setup() {
  size(750, 750);
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
  pBoard = new StringDict();
  sBoard = new StringDict();
  for (int a = 1; a < n+1; a++) {  
    for (int b = 0; b < 8; b++) {
      for (int c = 1; c < 4+1; c++) {
        if (c == 1) {
          if (b == 0 || b == 7) {
            pBoard.set(a+""+(char)(b+'a')+""+c, a+"Ri");
          } else if (b == 1 || b == 6) {
            pBoard.set(a+""+(char)(b+'a')+""+c, a+"N");
          } else if (b == 2 || b == 5) {
            pBoard.set(a+""+(char)(b+'a')+""+c, a+"B");
          } else if ((a%2 == 0)? b == 4 : b == 3) {
            pBoard.set(a+""+(char)(b+'a')+""+c, a+"Q");
          } else if ((a%2 == 0)? b == 3 : b == 4) {
            pBoard.set(a+""+(char)(b+'a')+""+c, a+"Ki");
          }
        } else if (c == 2) {
          pBoard.set(a+""+(char)(b+'a')+""+c, a+"p");
        } else {
          pBoard.set(a+""+(char)(b+'a')+""+c, "");
        }
      }
    }
  }
}

void draw() {
  PVector mouse = new PVector(mouseX, mouseY);
  translate(width/2, height/2);
  background(127);
  Board(n, width/4);
  resetMatrix();
  fill(color(map(player%n, 0, n, 0, 255), 255, 255));
  rect(0, 0, 50, 50);
  for (String b : pBoard.keyArray()) {
    if (pBoard.get(b) != "") {
      PVector pos = new PVector(int(sBoard.get(b).split("/")[0]), int(sBoard.get(b).split("/")[1]));
      fill((b == selected) ? 127 : color(map(side(pBoard.get(b)) - '1', 0, n, 0, 255), 255, 255));
      stroke((PVector.dist(pos, mouse) < 15) ? 0 : 127);
      if (piece(pBoard.get(b)) == 'p' || piece(pBoard.get(b)) == 'P') {
        shape(gPiece[0], pos.x, pos.y);
      } else if (piece(pBoard.get(b)) == 'R') {
        shape(gPiece[1], pos.x, pos.y);
      } else if (piece(pBoard.get(b)) == 'N') {
        shape(gPiece[2], pos.x, pos.y);
      } else if (piece(pBoard.get(b)) == 'B') {
        shape(gPiece[3], pos.x, pos.y);
      } else if (piece(pBoard.get(b)) == 'Q') {
        shape(gPiece[4], pos.x, pos.y);
      } else if (piece(pBoard.get(b)) == 'K') {
        shape(gPiece[5], pos.x, pos.y);
      }
    }
  }
  if (pBoard.hasKey(selected) && pBoard.get(selected) != "") {
    showHint();
  }
  if (showCoords) {
    for (String b : pBoard.keyArray()) {
      fill(127);
      text(b, int(sBoard.get(b).split("/")[0]), int(sBoard.get(b).split("/")[1]));
    }
  }
  if (inPromotion) {
    stroke(0);
    fill(127);
    rect(350, 350, 100, 100);
    fill(color(map(side(pBoard.get(selected)) - '1', 0, n, 0, 255), 255, 255));
    shape(gPiece[1], 375, 375);
    shape(gPiece[2], 425, 375);
    shape(gPiece[3], 375, 425);
    shape(gPiece[4], 425, 425);
  }
  if (xeque((char)(player%n + '1'))) {
    fill(0);
    rect(0, 0, 50, 50);
    fill(255);
    text("Xeque", 75, 75);
  }
  fill(0);
  rect(width - 50, height - 50, 50, 50);
  fill(255);
  text("Casas", width - 25, height - 25);
}

void Board(int p, float s) {
  sBoard = new StringDict();
  rotate(PI/p /*+ PI/p * player * 2*/);
  if (beginAnimation != 0) {
    //rotate(PI/p/15*(frameCount - beginAnimation));
    sBoard = new StringDict();
    if (beginAnimation + 3/*0*/ == frameCount) {
      player++;
      beginAnimation = 0;
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
        fill(b ? color(map(round(c/2), 0, p, 0, 255), 255, 75) : color(map(round(c/2), 0, p, 0, 255), 75, 255));
      else
        fill(b ? color(map(round(c/2), 0, p, 0, 255), 75, 255) : color(map(round(c/2), 0, p, 0, 255), 255, 75));
      noStroke();
      beginShape();
      vertex(x, y);
      vertex(x+r/4*cos(a), y+r/4*sin(a));
      vertex(x+r/4*cos(a), y+r/4+r/4*sin(a));
      vertex(x, y+r/4);
      endShape(CLOSE);
      if (!sBoard.hasKey(id)) {
        PVector pos = new PVector(x, y).lerp(new PVector(x+r/4*cos(a), y+r/4+r/4*sin(a)), 0.5);
        sBoard.set(id, (int)screenX(pos.x, pos.y) + "/" + (int)screenY(pos.x, pos.y));
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
  for (String b : pBoard.keyArray()) {
    PVector pos = new PVector(int(sBoard.get(b).split("/")[0]), int(sBoard.get(b).split("/")[1]));
    if (validity(b)) {
      switch(piece(pBoard.get(selected))) {
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
    pBoard.hasKey(from) && pBoard.get(from) != "" &&
    (pBoard.get(to) == "" || army(pBoard.get(to)) != army(pBoard.get(from))) &&
    (army(pBoard.get(from)) - '1') % n == player % n
    ) {
    StringList list = new StringList();
    switch(piece(pBoard.get(from))) {
    case 'p':
      if (flag(pBoard.get(from)) == 'e') {
        recursive(list, from, Dir.E, Opt.CAPTURE_ONLY);
        recursive(list, from, Dir.W, Opt.CAPTURE_ONLY);
      }
      if (army(pBoard.get(from)) == side(from)) {
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
      if (flag(pBoard.get(from)) == 'i') { // Se o rei não foi movido
        if (pBoard.get((char)army(pBoard.get(from)) + "f1") == "" && pBoard.get((char)army(pBoard.get(from)) + "g1") == "" && flag(pBoard.get((char)army(pBoard.get(from)) + "h1")) == 'i') {
          list.append((char)army(pBoard.get(from)) + "g1");
        } else if (pBoard.get((char)army(pBoard.get(from)) + "b1") == "" && pBoard.get((char)army(pBoard.get(from)) + "c1") == "" && pBoard.get((char)army(pBoard.get(from)) + "d1") == "" && flag(pBoard.get((char)army(pBoard.get(from)) + "a1")) == 'i') {
          list.append((char)army(pBoard.get(from)) + "c1");
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
    (o == Opt.WALK_ONLY && pBoard.get(square) == "")
    ) {
    if (
      square == origin ||
      o != Opt.CAPTURE_ONLY ||
      (o == Opt.CAPTURE_ONLY && pBoard.get(square) != "")
      ) {
      if (
        square == origin ||                                                                    // Quadrado inicial
        o == Opt.JUMP ||                                                                       // Ignora peças
        (pBoard.get(square) == "" ||                                                           // Quadrado Vazio
        (pBoard.get(square) != "" && army(pBoard.get(origin)) != army(pBoard.get(square))))    // Para antes da própria peça
        )
      {
        switch(d) {
        case N:
          if (level(square) == '1' && side(origin) != side(square) || (pBoard.get(square) != "" && army(pBoard.get(origin)) != army(pBoard.get(square)))) {
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
          if (level(square) == '1' && side(origin) == side(square) || (pBoard.get(square) != "" && army(pBoard.get(origin)) != army(pBoard.get(square)))) {
            rec.append(square);
            break;
          } else {
            rec.append(square);
            if (level(square) != '1')
              recursive(rec, origin, next(square, d), d, o);
            break;
          }
        case E:
          if (letter(square) == 'h' || (pBoard.get(square) != "" && army(pBoard.get(origin)) != army(pBoard.get(square)))) {
            rec.append(square);
            break;
          } else {
            rec.append(square);
            recursive(rec, origin, next(square, d), d, o);
            break;
          }
        case W:
          if (letter(square) == 'a' || (pBoard.get(square) != "" && army(pBoard.get(origin)) != army(pBoard.get(square)))) {
            rec.append(square);
            break;
          } else {
            rec.append(square);
            recursive(rec, origin, next(square, d), d, o);
            break;
          }
        case NE:
          if (level(square) == '1' && side(origin) != side(square) || letter(square) == 'h' || (pBoard.get(square) != "" && army(pBoard.get(origin)) != army(pBoard.get(square)))) {
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
          if (level(square) == '1' && side(origin) != side(square) || letter(square) == 'a' || (pBoard.get(square) != "" && army(pBoard.get(origin)) != army(pBoard.get(square)))) {
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
          if (level(square) == '1' && side(origin) == side(square) || letter(square) == 'h' || (pBoard.get(square) != "" && army(pBoard.get(origin)) != army(pBoard.get(square)))) {
            rec.append(square);
            break;
          } else {
            rec.append(square);
            if (level(square) != '1')
              recursive(rec, origin, next(square, d), d, o);
            break;
          }
        case SW:
          if (level(square) == '1' && side(origin) == side(square) || letter(square) == 'a' || (pBoard.get(square) != "" && army(pBoard.get(origin)) != army(pBoard.get(square)))) {
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
  for (String s : pBoard.keyArray()) {
    if (!list.hasValue(s)) {
      result.append(s);
    }
  }
  return result;
}

boolean xeque(char side) {
  for (String k : pBoard.keyArray()) {
    if (pBoard.get(k) != "" && army(pBoard.get(k)) == side && piece(pBoard.get(k)) == 'K') {
      for (String b : pBoard.keyArray()) {
        if (pBoard.get(b) != "" && validity(b, k)) {
          println("XEQUE "+(char)side);
          return true;
        }
      }
    }
  }
  return false;
}

void mousePressed() {
  String last = selected;
  PVector mouse = new PVector(mouseX, mouseY);
  if (inPromotion) {
    if (PVector.dist(new PVector(375, 375), mouse) < 20) {
      pBoard.set(selected, (char)army(pBoard.get(selected)) + "R");
    } else 
    if (PVector.dist(new PVector(425, 375), mouse) < 20) {
      pBoard.set(selected, (char)army(pBoard.get(selected)) + "N");
    } else 
    if (PVector.dist(new PVector(375, 425), mouse) < 20) {
      pBoard.set(selected, (char)army(pBoard.get(selected)) + "B");
    } else 
    if (PVector.dist(new PVector(425, 425), mouse) < 20) {
      pBoard.set(selected, (char)army(pBoard.get(selected)) + "Q");
    } 
    if (piece(pBoard.get(selected)) != 'p') {
      inPromotion = false;
      selected = "";
      beginAnimation = frameCount;
    }
  } else {
    for (String b : pBoard.keyArray()) {
      PVector pos = new PVector(int(sBoard.get(b).split("/")[0]), int(sBoard.get(b).split("/")[1]));
      if (PVector.dist(pos, mouse) < 20) {
        selected = b;
        if (validity(last, selected)) {
          lastPlay = pBoard.get(last).charAt(1) + last + " → " + ((pBoard.get(selected) != "") ? pBoard.get(selected).charAt(1): "") + selected;
          if (piece(pBoard.get(last)) == 'K' && flag(pBoard.get(last)) == 'i' && letter(selected) == 'g') { // Pq. Roque
            pBoard.set((char)army(pBoard.get(last)) + "f1", (char)army(pBoard.get(last)) + "R");
            pBoard.set((char)army(pBoard.get(last)) + "h1", "");
            lastPlay = "O-O";
          }
          if (piece(pBoard.get(last)) == 'K' && flag(pBoard.get(last)) == 'i' && letter(selected) == 'c') { // Gd. Roque
            pBoard.set((char)army(pBoard.get(last)) + "d1", (char)army(pBoard.get(last)) + "R");
            pBoard.set((char)army(pBoard.get(last)) + "a1", "");
            lastPlay = "O-O-O";
          }
          rollUp += lastPlay + "/n";
          println(lastPlay);
          if (piece(pBoard.get(last)) == 'p' && level(last) == '2' && level(selected) == '4')
            pBoard.set(last, pBoard.get(last) + "e");
          if (flag(pBoard.get(last)) == 'e' && level(last) == '4' || flag(pBoard.get(last)) == 'i')
            pBoard.set(last, pBoard.get(last).substring(0, 2));
          pBoard.set(selected, pBoard.get(last));
          pBoard.set(last, "");
          if (piece(pBoard.get(selected)) == 'p' && level(selected) == '1') {
            inPromotion = true;
          } else {
            selected = "";
            beginAnimation = frameCount;
          }
        }
        break;
      } else {
        selected = "";
      }
    }
  }
  if (mouseX > width - 50 && mouseY > height - 50) {
    showCoords = !showCoords;
  }
}
