public class Menu_bar extends JFrame implements ActionListener {
  PApplet chain;
  JFrame frame;
  JMenu import_menu = new JMenu("File");
  JMenuItem copy_save = new JMenuItem("Copy Save Name");
  JMenuItem new_game = new JMenuItem("New Game");
  JMenuItem old_game = new JMenuItem("Load Game");
  JMenu web_game = new JMenu("Web Game");
  JMenuItem new_web_game = new JMenuItem("Start Web Game");
  JMenuItem old_web_game = new JMenuItem("Join Web Game");
  JMenuItem action_exit = new JMenuItem("Exit");

  JMenu options_menu = new JMenu("Options");
  JMenuItem animated = new JMenuItem((playerRotate?"☑":"☐")+" Rotate");
  JMenuItem drawCoords = new JMenuItem((showCoords?"☑":"☐")+" Show Coords");
  JMenuItem logView = new JMenuItem("View Log");

  JMenu about_menu = new JMenu("About");
  JMenuItem credits = new JMenuItem("Credits");
  JPanel panel;

  public Menu_bar(PApplet app) {
    chain = app;
    frame = (JFrame) ((processing.awt.PSurfaceAWT.SmoothCanvas)app.getSurface().getNative()).getFrame();
    panel =  new JPanel();
    panel.setOpaque(false);

    // Creates a menubar for a JFrame
    JMenuBar menu_bar = new JMenuBar();
    frame.setJMenuBar(menu_bar);

    import_menu.setMnemonic('F');
    copy_save.setMnemonic('C');
    new_game.setMnemonic('N');
    old_game.setMnemonic('L');/*
    web_game.setMnemonic('W');
     new_web_game.setMnemonic('S');
     old_web_game.setMnemonic('J');*/
    action_exit.setMnemonic('E');
    options_menu.setMnemonic('O');
    animated.setMnemonic('R');
    drawCoords.setMnemonic('C');
    logView.setMnemonic('L');
    about_menu.setMnemonic('A');
    credits.setMnemonic('D');

    menu_bar.add(import_menu);
    copy_save.addActionListener(this);
    import_menu.add(copy_save);
    new_game.addActionListener(this);
    import_menu.add(new_game);
    old_game.addActionListener(this);
    import_menu.add(old_game);/*
    new_web_game.addActionListener(this);
     web_game.add(new_web_game);
     old_web_game.addActionListener(this);
     web_game.add(old_web_game);
     import_menu.add(web_game);*/
    import_menu.addSeparator();
    action_exit.addActionListener(this);
    import_menu.add(action_exit);

    menu_bar.add(options_menu);
    animated.addActionListener(this);
    options_menu.add(animated);
    drawCoords.addActionListener(this);
    options_menu.add(drawCoords);
    options_menu.addSeparator();
    logView.addActionListener(this);
    options_menu.add(logView);

    menu_bar.add(about_menu);
    credits.addActionListener(this);
    about_menu.add(credits);

    frame.setVisible(true);
  }

  public void actionPerformed(ActionEvent e) {
    String str = e.getActionCommand();

    Object source = e.getSource();
    if (source == copy_save) {
      StringSelection stringSelection = new StringSelection(saveName);
      Clipboard clpbrd = Toolkit.getDefaultToolkit().getSystemClipboard();
      clpbrd.setContents(stringSelection, null);
    } else if (source == new_game) {
      notStarted = true;
      NewGamePopUp popup = new NewGamePopUp(chain);
    } else if (source == old_game) {
      notStarted = true;
      JFileChooser chooser = new JFileChooser();
      FileNameExtensionFilter filter = new FileNameExtensionFilter("Nchess save file", "ncs");
      chooser.setFileFilter(filter);
      int returnVal = chooser.showOpenDialog(this);
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        args = new String[1];
        args[0] = chooser.getSelectedFile().getPath();
        buildBoard();
        notStarted = false;
      }
    } else if (source == new_web_game) {
      notStarted = true;
      NewWebGamePopUp popup = new NewWebGamePopUp(chain);
    } else if (source == old_web_game) {
      notStarted = true;
      LoadWebGamePopUp popup = new LoadWebGamePopUp(chain);
    } else if (source == action_exit) {
      exit();
    } else if (source == animated) {
      playerRotate = !playerRotate;
      animated.setText((playerRotate?"☑":"☐")+" Rotate");
    } else if (source == drawCoords) {
      showCoords = !showCoords;
      drawCoords.setText((showCoords?"☑":"☐")+" Show Coords");
    } else if (source == logView) {
      logPopUp = new LogPopUp(chain);
    } else if (source == credits) {
      CreditsPopUp creditsPopUp = new CreditsPopUp(chain);
    }
  }
}

Menu_bar mp;
void buildMenuBar() {
  mp = new Menu_bar(this);
}
