public class Piece {
  int[][] movement = new int[15][15];
  int[][] capture  = new int[15][15];
  IntList[] blockers;
  
  StringList[][] mask = new StringList[15][15];
  int army;
  String symbol;
  String name;

  public Piece(String s, int a) {
    army = a;
    symbol = s;
    JSONObject json = loadJSONObject(s+".json");
    name = json.getString("name");
    for (int i = 0; i < 15; i++) {
      movement[i] = json.getJSONArray("movement").getJSONArray(i).getIntArray();
    }
  }

  public void updateMask(String coord) {
    for (int i = 0; i < 15; i++) {
      for (int j = 0; j < 15; j++) {
        mask[i][j].clear();
      }
    }
    mask[7][7].append(coord);
  }
  
  private int getMaskedMovement(String coord){
    for (int i = 0; i < 15; i++) {
      for (int j = 0; j < 15; j++) {
        if (mask[i][j].hasValue(coord))
        return movement[i][j];
      }
    }
    return 0;
  }
  
  private int getMaskedCapture(String coord){
    for (int i = 0; i < 15; i++) {
      for (int j = 0; j < 15; j++) {
        if (mask[i][j].hasValue(coord))
        return capture[i][j];
      }
    }
    return 0;
  }
}
