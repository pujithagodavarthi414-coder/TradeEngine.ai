using System;

namespace Btrak.Models
{
    public class LeaveApplicationMailSendingOutputModel
    {
        public Guid? UserId { get; set; }
        public string FullName { get; set; }
        public string UserName { get; set; }

    }
}
