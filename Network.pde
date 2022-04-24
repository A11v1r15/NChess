import java.net.*;
import java.util.*;
import java.io.*;
import java.nio.charset.StandardCharsets;

int saveId;

public void post(boolean firstTime) {
  try {
    URL url = new URL("https://a11v1r15-nchess.000webhostapp.com/api.php/records/matches" + (firstTime? "" : "/" + save.getInt("netId")));
    URLConnection con = url.openConnection();
    HttpURLConnection http = (HttpURLConnection)con;
    http.setRequestMethod(firstTime? "POST" : "PUT"); // PUT is another valid option
    http.setDoOutput(true);

    Map<String, String> arguments = new HashMap<String, String>();
    arguments.put("name", saveName);
    arguments.put("board", save.toString());
    StringJoiner sj = new StringJoiner("&");
    for (Map.Entry<String, String> entry : arguments.entrySet())
      sj.add(URLEncoder.encode(entry.getKey(), "UTF-8") + "=" 
        + URLEncoder.encode(entry.getValue(), "UTF-8"));
    byte[] out = sj.toString().getBytes(StandardCharsets.UTF_8);
    int outLength = out.length;

    http.setFixedLengthStreamingMode(outLength);
    http.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    http.connect();
    OutputStream os = http.getOutputStream();
    os.write(out);
    println(http.getResponseMessage());
    println(http.getResponseCode());
  }
  catch(MalformedURLException e) {
    println("MalformedURLException: " + e);
    return;
  }
  catch(IOException e) {
    println("IOException: " + e);
    return;
  }
}

public void getFromWeb(String name) { //test: L2B3JA8D
  try {
    URL url = new URL("https://a11v1r15-nchess.000webhostapp.com/api.php/records/matches?filter=name,eq,"+name);
    URLConnection yc = url.openConnection();
    BufferedReader in = new BufferedReader(new InputStreamReader(yc.getInputStream()));
    String inputLine;
    inputLine = in.readLine();
    in.close();
    JSONObject records = parseJSONObject(inputLine);
    save = parseJSONObject(records.getJSONArray("records").getJSONObject(0).getString("board").replace("â\u2020\u2019", "→"));
    save.setString("netId", records.getJSONArray("records").getJSONObject(0).getInt("id") + "");
    saveJSONObject(save, "Saves/@" + save.getString("name")+".ncs");
    args = new String[1];
    args[0] = "Saves/@" + save.getString("name")+".ncs";
    buildBoard();
  }
  catch(MalformedURLException e) {
    println("MalformedURLException: " + e);
    return;
  }
  catch(IOException e) {
    println("IOException: " + e);
    return;
  }
}
