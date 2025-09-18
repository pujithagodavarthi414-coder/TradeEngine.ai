using System;

namespace Btrak.Models.TimeSheet
{
    public class TimeFeedHistorySpReturnModel
    {
        public DateTime NewValue { get; set; }
        public string FieldName { get; set; }
        public string UserName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int? TotalCount { get; set; }
    }
}