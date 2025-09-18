using System.Text;
using System;

namespace Btrak.Models.FoodOrders
{
    public class LatestFoodOrdersModel
    {
        public int PageSize { get; set; } = 1000;
        public int PageNumber { get; set; } = 1;
        public string SortBy { get; set; }
        public bool SortDirectionAsc { get; set; }
        public string SearchText { get; set; }
        public string SortDirection => SortDirectionAsc ? "ASC" : "DESC";
        public bool IsRecent { get; set; }
        public Guid? EntityId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", PageSize = " + PageSize);
            stringBuilder.Append(", PageNumber = " + PageNumber);
            stringBuilder.Append(", SortBy = " + SortBy);
            stringBuilder.Append(", SortDirectionAsc = " + SortDirectionAsc);
            stringBuilder.Append(", SortDirection = " + SortDirection);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", IsRecent = " + IsRecent);
            return stringBuilder.ToString();
        }
    }
}
