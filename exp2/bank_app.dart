void main() {
  // print('Welcome to the Bank App!');
  print("\n Creating savings account for Ashvatth...");
  SavingsAccount savings = SavingsAccount("SA1001", "Ashvatth", 5000.0);
  savings.displayAccountInfo();

  print("\nCreating current account for Joshi...");
  CurrentAccount current = CurrentAccount("CA1001", "Joshi", 10000.0);
  current.displayAccountInfo();

  print("\n--Savings Account Operations--");
  savings.deposit(500.0);
  savings.withdraw(200.0);
  savings.addInterest(5.0); // 5% interest
  savings.withdraw(3000.0);
  print("\nFinal Savings Account Info:");
  savings.displayAccountInfo();

  print("\n--Current Account Operations--");
  current.deposit(1000.0);
  current.withdraw(4000.0);
  current.deductMonthlyCharge(100.0);
  current.withdraw(2000.0);
  print("\nFinal Current Account Info:");
  current.displayAccountInfo();

  print("\n Testing encapsulation...");
  print("Try set negative balance: ");
  savings.balance = -500.0;
  print("Balance after attempt: ");
  savings.displayAccountInfo();
}

// Encapsulation
class BankAccount {
  // private data members
  String _accountNumber;
  String _accountHolderName;
  double _balance;

  // constructor
  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  // getter for balance
  String get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  double get balance => _balance;

  // setter
  set balance(double newBalance) {
    if (newBalance >= 0) {
      _balance = newBalance;
    } else {
      print("Balance cannot be negative.");
    }
  }

  // deposit method
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print("Deposited \$${amount}. New balance: \$${_balance}");
    } else {
      print("Deposit amount must be positive.");
    }
  }

  // withdraw method
  void withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      print("Withdrew \$${amount}. New balance: \$${_balance}");
    } else {
      print("Insufficient balance or invalid amount.");
    }
  }

  // display account info
  void displayAccountInfo() {
    print("Account Number: $_accountNumber");
    print("Account Holder: $_accountHolderName");
    print("Balance: \$$_balance");
  }
}

// Inheritance - SavingsAccount
class SavingsAccount extends BankAccount {
  SavingsAccount(String accNum, String name, double bal)
    : super(accNum, name, bal);

  void addInterest(double rate) {
    double interest = _balance * (rate / 100);
    deposit(interest);
  }
}

// Inheritance - CurrentAccount
class CurrentAccount extends BankAccount {
  CurrentAccount(String accNum, String name, double bal)
    : super(accNum, name, bal);

  void deductMonthlyCharge(double charge) {
    print("Deducting monthly charge of \$${charge}");
    withdraw(charge);
  }
}
