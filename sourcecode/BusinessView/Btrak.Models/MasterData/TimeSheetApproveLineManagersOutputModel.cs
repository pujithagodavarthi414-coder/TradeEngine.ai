using System;

namespace Btrak.Models.MasterData
{
    public class TimeSheetApproveLineManagersOutputModel
    {
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string ProfileImage { get; set; }
        public bool IsActive { get; set; }
    }
}
