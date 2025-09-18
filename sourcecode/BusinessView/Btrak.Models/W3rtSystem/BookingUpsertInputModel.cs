using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.W3rtSystem
{
    public class BookingUpsertInputModel : InputModelBase
    {

        public  BookingUpsertInputModel() : base(InputTypeGuidConstants.BookingUpsertInputCommandTypeGuid)
         {
         }
        public Guid? BookingId { get; set; }
        public Guid? RoomId { get; set; }
        public string RoomAmitites { get; set; }
        public string VenueAmitites { get; set; }
        public decimal Tax { get; set; }
        public decimal PaidAmount { get; set; }
        public decimal ActualExpensesAmount { get; set; }
        public decimal DamagesAmount { get; set; }
        public decimal RefundedAmount { get; set; }
        public DateTime DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public DateTime? CanceledDate { get; set; }
        public Guid? EventTypeId { get; set; }
        public string FromTime { get; set; }
        public string ToTime { get; set; }
        public bool IsMultiple { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BookingId" + BookingId);
            stringBuilder.Append("RoomId" + RoomId);
            stringBuilder.Append("RoomAmitites" + RoomAmitites);
            stringBuilder.Append("VenueAmitites" + VenueAmitites);
            stringBuilder.Append("Tax" + Tax);
            stringBuilder.Append("PaidAmount" + PaidAmount);
            stringBuilder.Append("ActualExpensesAmount" + ActualExpensesAmount);
            stringBuilder.Append("DamagesAmount" + DamagesAmount);
            stringBuilder.Append("RefundedAmount" + RefundedAmount);
            stringBuilder.Append("DateFrom" + DateFrom);
            stringBuilder.Append("DateTo" + DateTo);
            stringBuilder.Append("CanceledDate" + CanceledDate);
            stringBuilder.Append("EventTypeId" + EventTypeId);
            stringBuilder.Append("FromTime" + FromTime);
            stringBuilder.Append("Totime" + ToTime);
            stringBuilder.Append("IsMultiple" + IsMultiple);
            return base.ToString();
        }

    }
}
