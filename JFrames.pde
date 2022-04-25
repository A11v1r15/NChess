import javax.swing.*;
import java.awt.event.*;
import javax.swing.filechooser.*;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.datatransfer.*;
import java.awt.Toolkit;

public class StartPopUp implements ActionListener {

  final JFrame parent = new JFrame("NChess");
  JButton loadGame = new JButton();
  JButton newGame = new JButton();
  JButton loadWeb = new JButton();
  JButton newWeb = new JButton();
  JPanel panel = new JPanel();
  PApplet chain;

  public StartPopUp(PApplet app) {
    chain = app;
    newGame.setText("New Game");
    newGame.addActionListener(this);
    loadGame.setText("Load Game");
    loadGame.addActionListener(this);
    newWeb.setText("Start Web Game");
    newWeb.addActionListener(this);
    loadWeb.setText("Join Web Game");
    loadWeb.addActionListener(this);
    panel.setLayout(new FlowLayout());
    panel.add(newGame);
    panel.add(loadGame);
    panel.add(newWeb);
    panel.add(loadWeb);
    parent.add(panel);
    parent.pack();
    parent.setSize((int)(parent.getWidth() * 0.6), (int)(parent.getHeight()*1.6));
    parent.setResizable(false);
    parent.setLocation((displayWidth - parent.getWidth())/2, (displayHeight - parent.getHeight())/2);
    parent.setVisible(true);

    parent.addWindowListener(new java.awt.event.WindowAdapter() {
      @Override
        public void windowClosing(java.awt.event.WindowEvent windowEvent) {
        exit();
      }
    }
    );
  }

  public void actionPerformed(ActionEvent e) {
    Object source = e.getSource();
    if (source == loadGame) {
      JFileChooser chooser = new JFileChooser();
      FileNameExtensionFilter filter = new FileNameExtensionFilter("Nchess save file", "ncs");
      chooser.setFileFilter(filter);
      int returnVal = chooser.showOpenDialog(parent);
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        parent.setVisible(false);
        args = new String[1];
        args[0] = chooser.getSelectedFile().getPath();
        buildBoard();
        webPlay = false;
        notStarted = false;
      }
      println("Selected new file");
    } else if (source == newGame) {
      parent.setVisible(false);
      NewGamePopUp popup = new NewGamePopUp(chain);
    } else if (source == newWeb) {
      parent.setVisible(false);
      NewWebGamePopUp popup = new NewWebGamePopUp(chain);
    } else if (source == loadWeb) {
      parent.setVisible(false);
      LoadWebGamePopUp popup = new LoadWebGamePopUp(chain);
    }
  }
}

public class NewGamePopUp implements ActionListener {
  PApplet chain;
  final JFrame parent = new JFrame("NChess - New Game");
  JLabel  playersPanel = new JLabel ();
  JTextField players = new JTextField(n+"", 3);
  JButton startGame = new JButton();
  JPanel panel = new JPanel();

  public NewGamePopUp(PApplet app) {
    chain = app;
    startGame.setText("Start Game");
    startGame.addActionListener(this);
    playersPanel.setText("Players:");
    panel.setLayout(new FlowLayout());
    panel.add(playersPanel);
    panel.add(players);
    panel.add(startGame);
    parent.add(panel);
    parent.pack();
    parent.setSize(150, 120);
    parent.setResizable(false);
    parent.setLocation((displayWidth - parent.getWidth())/2, (displayHeight - parent.getHeight())/2);
    parent.setVisible(true);

    parent.addWindowListener(new java.awt.event.WindowAdapter() {
      @Override
        public void windowClosing(java.awt.event.WindowEvent windowEvent) {
        StartPopUp popup = new StartPopUp(chain);
      }
    }
    );
    players.addActionListener( new AbstractAction()
    {
      @Override
        public void actionPerformed(ActionEvent e)
      {
        go();
      }
    }
    );
  }

  public void actionPerformed(ActionEvent e) {
    Object source = e.getSource();
    if (source == startGame) {
      go();
    }
  }

  private void go() {
    args = null;
    n = max(2, parseInt(players.getText()));
    parent.setVisible(false);
    webPlay = false;
    buildBoard();
    notStarted = false;
  }
}

public class NewWebGamePopUp implements ActionListener {
  PApplet chain;
  final JFrame parent = new JFrame("NChess - New Web Game");
  JLabel  playersPanel = new JLabel ();
  JTextField players = new JTextField(n+"", 3);
  JButton startGame = new JButton();
  JPanel panel = new JPanel();

  public NewWebGamePopUp(PApplet app) {
    chain = app;
    startGame.setText("Start Web Game");
    startGame.addActionListener(this);
    playersPanel.setText("Players:");
    panel.setLayout(new FlowLayout());
    panel.add(playersPanel);
    panel.add(players);
    panel.add(startGame);
    parent.add(panel);
    parent.pack();
    parent.setSize(170, 120);
    parent.setResizable(false);
    parent.setLocation((displayWidth - parent.getWidth())/2, (displayHeight - parent.getHeight())/2);
    parent.setVisible(true);

    parent.addWindowListener(new java.awt.event.WindowAdapter() {
      @Override
        public void windowClosing(java.awt.event.WindowEvent windowEvent) {
        StartPopUp popup = new StartPopUp(chain);
      }
    }
    );
    players.addActionListener( new AbstractAction()
    {
      @Override
        public void actionPerformed(ActionEvent e)
      {
        go();
      }
    }
    );
  }

  public void actionPerformed(ActionEvent e) {
    Object source = e.getSource();
    if (source == startGame) {
      go();
    }
  }

  private void go() {
    args = null;
    n = max(2, parseInt(players.getText()));
    parent.setVisible(false);
    webPlay = true;
    buildBoard();
    save.setInt("netId", post(true));
    notStarted = false;
  }
}

public class LoadWebGamePopUp implements ActionListener {
  PApplet chain;
  final JFrame parent = new JFrame("NChess - Load Game from Web");
  JLabel  playersPanel = new JLabel ();
  JTextField players = new JTextField(8);
  JLabel  emptyPanel = new JLabel ();
  JButton startGame = new JButton();
  JPanel panel = new JPanel();

  public LoadWebGamePopUp(PApplet app) {
    chain = app;
    startGame.setText("Load Game");
    startGame.addActionListener(this);
    playersPanel.setText("Save Name:");
    panel.setLayout(new FlowLayout());
    panel.add(playersPanel);
    panel.add(players);
    panel.add(emptyPanel);
    panel.add(startGame);
    parent.add(panel);
    parent.pack();
    parent.setSize(220, 120);
    parent.setLocation((displayWidth - parent.getWidth())/2, (displayHeight - parent.getHeight())/2);
    parent.setVisible(true);

    parent.addWindowListener(new java.awt.event.WindowAdapter() {
      @Override
        public void windowClosing(java.awt.event.WindowEvent windowEvent) {
        StartPopUp popup = new StartPopUp(chain);
      }
    }
    );
    players.addActionListener( new AbstractAction()
    {
      @Override
        public void actionPerformed(ActionEvent e)
      {
        go();
      }
    }
    );
  }

  public void actionPerformed(ActionEvent e) {
    Object source = e.getSource();
    if (source == startGame) {
      go();
    }
  }

  private void go() {
    getFromWeb(players.getText());
    parent.setVisible(false);
    webPlay = true;
    buildBoard();
    notStarted = false;
  }
}

public class LogPopUp {
  PApplet chain;
  final JFrame parent = new JFrame("Log - " + (webPlay?"@":"") + saveName);
  JLabel playersPanel = new JLabel();

  public LogPopUp(PApplet app) {
    chain = app;
    JFrame frame = (JFrame) ((processing.awt.PSurfaceAWT.SmoothCanvas)app.getSurface().getNative()).getFrame();
    update();
    playersPanel.setVerticalAlignment(JLabel.NORTH);
    parent.add(playersPanel);
    parent.pack();
    parent.setSize(100, frame.getHeight());
    parent.setLocation(frame.getX()+frame.getWidth(), frame.getY());
    parent.setVisible(true);
  }

  public void update() {
    String logText = "<html><div style='background-color: #111111;'>";
    int logLength = save.getJSONArray("log").getStringArray().length;
    for (int i = (logLength > 30 ? logLength - 30 : 0); i < logLength; i++) {
      logText += "<span style='color:#" + hex(color(map(i%n, 0, n, 0, 255), 255, 255)).substring(2) + "'>";
      logText += save.getJSONArray("log").getString(i);
      logText += "</span><br>";
    }
    logText += "</div></html>";
    playersPanel.setText(logText);
  }
}
