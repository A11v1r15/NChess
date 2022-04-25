import http.requests.*;

int saveId;

public void post(boolean firstTime) {
  if (firstTime) {
    PostRequest post = new PostRequest("https://a11v1r15-nchess.000webhostapp.com/api.php/records/matches");
    post.addHeader("Content-Type", "application/x-www-form-urlencoded;");
    post.addData("name", saveName);
    post.addData("board", save.toString());
    post.send();
    saveId = parseInt(post.getContent());
  } else {
    PutRequest put = new PutRequest("https://a11v1r15-nchess.000webhostapp.com/api.php/records/matches/" + save.getInt("netId"));
    put.addHeader("Content-Type", "application/x-www-form-urlencoded;");
    put.addData("board", save.toString());
    put.send();
    println("Reponse Content: " + put.getContent());
    println("Reponse Content-Length Header: " + put.getHeader("Content-Length"));
  }
}

public void getFromWeb(String name) { //test: L2B3JA8D
  GetRequest get = new GetRequest("https://a11v1r15-nchess.000webhostapp.com/api.php/records/matches?filter=name,eq,"+name);
  get.send();
  JSONObject records = parseJSONObject(get.getContent());
  save = parseJSONObject(records.getJSONArray("records").getJSONObject(0).getString("board").replace("â\u2020\u2019", "→"));
  save.setString("netId", records.getJSONArray("records").getJSONObject(0).getInt("id") + "");
  saveJSONObject(save, "Saves/@" + save.getString("name")+".ncs");
  args = new String[1];
  args[0] = "Saves/@" + save.getString("name")+".ncs";
  buildBoard();
}
