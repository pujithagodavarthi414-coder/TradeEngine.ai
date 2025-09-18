using System;
using System.Text;

namespace Btrak.Models.FoodOrders
{
    public class FoodOrderDashboardModel
    {
        public DateTime? OrderDate { get; set; }
        public decimal? Amount { get; set; }
        public int? OrdersCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", OrderDate = " + OrderDate);
            stringBuilder.Append(", Amount = " + Amount);
            stringBuilder.Append(", OrdersCount = " + OrdersCount);
            return stringBuilder.ToString();
        }
    }
}
