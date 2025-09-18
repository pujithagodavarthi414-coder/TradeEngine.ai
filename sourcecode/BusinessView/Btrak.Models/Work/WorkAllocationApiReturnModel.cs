using System;
using System.Text;

namespace Btrak.Models.Work
{
    public class WorkAllocationApiReturnModel
    {
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public decimal WorkAllocated { get; set; }
        public decimal MinWork { get; set; }
        public decimal MaxWork { get; set; }
        public DateTime? MaxDeadLineDate { get; set; }
        public DateTime? Date { get; set; }
        public string MaxDeadLineDateOn { get; set; }
        public bool IsSupport { get; set; }
        public string Color { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", WorkAllocated = " + WorkAllocated);
            stringBuilder.Append(", MinWork = " + MinWork);
            stringBuilder.Append(", MaxWork = " + MaxWork);
            stringBuilder.Append(", MaxDeadLineDate = " + MaxDeadLineDate);
            stringBuilder.Append(", MaxDeadLineDateOn = " + MaxDeadLineDateOn);
            stringBuilder.Append(", IsSupport = " + IsSupport);
            stringBuilder.Append(", Color = " + Color);
            return stringBuilder.ToString();
        }
    }
}
