using System;

namespace Btrak.Models.ActTracker
{
    public class MostProductiveUsersOutputModel
    {
        public Guid UserId { get; set; }
        public string FullName { get; set; }
        public string ProfileImage { get; set; }

        public decimal SpentPercent { get; set; }
        public string SpentTime { get; set; }
        public string TotalTime { get; set; }
    }
}
