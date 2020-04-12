class Position{
  double tipPercentage;
  String title = "", name = "";
  int tipOutAmount;

  Position(this.title, this.name, this.tipPercentage){
    tipOutAmount = 0;
  }

  setTipOutAmount(int amount){
    this.tipOutAmount = amount;
  }
}