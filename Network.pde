import java.net.*;
import java.util.*;
import java.io.*;
import java.nio.charset.StandardCharsets;

int saveId;

public void post() {
  try {
    URL url = new URL("https://a11v1r15-nchess.000webhostapp.com/api.php/records/matches");
    URLConnection con = url.openConnection();
    HttpURLConnection http = (HttpURLConnection)con;
    http.setRequestMethod("POST"); // PUT is another valid option
    http.setDoOutput(true);

    Map<String, String> arguments = new HashMap<String, String>();
    arguments.put("name", saveName);
    arguments.put("board", save.toString());
    StringJoiner sj = new StringJoiner("&");
    for (Map.Entry<String, String> entry : arguments.entrySet())
      sj.add(URLEncoder.encode(entry.getKey(), "UTF-8") + "=" 
        + URLEncoder.encode(entry.getValue(), "UTF-8"));
    byte[] out = sj.toString().getBytes(StandardCharsets.UTF_8);
    int length = out.length;

    http.setFixedLengthStreamingMode(length);
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

public void getFromNet(String name) {
  try {
    URL url = new URL("https://a11v1r15-nchess.000webhostapp.com/api.php/records/matches?filter=name,eq,"+name);
    URLConnection yc = url.openConnection();
    BufferedReader in = new BufferedReader(new InputStreamReader(yc.getInputStream()));
    String inputLine;
    inputLine = in.readLine();
    in.close();
    JSONObject records = parseJSONObject(inputLine);
    save = parseJSONObject(records.getJSONArray("records").getJSONObject(0).getString("board"));
    saveJSONObject(save, save.getString("name")+".ncs");
    args = new String[1];
    args[0] = save.getString("name")+".ncs";
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