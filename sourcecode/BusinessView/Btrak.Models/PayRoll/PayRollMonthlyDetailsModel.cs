namespace Btrak.Models.PayRoll
{
    public class PayRollMonthlyDetailsModel
    {
        public int Employees { get; set; }
        public string NetPay { get; set; }
        public string GrossPay { get; set; }
        public string Deductions { get; set; }
        public int WorkDays { get; set; }
        public int HoldEmployees { get; set; }
        public string Earnings { get; set; }
    }
}
