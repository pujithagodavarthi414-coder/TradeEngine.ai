using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.HrManagement
{
    public class ReadAndUnReadUsersOfAnnouncementApiReturnModel
    {
        public Guid? AnnouncementId { get; set; }
        public string Announcement { get; set; }
        public bool IsRead { get; set; }
        public string AnnouncedBy { get; set; }
        public string AnnouncedByUserImage { get; set; }
        public Guid? AnnouncedById { get; set; }
        public DateTime AnnouncedOn { get; set; }
        public int TotalAnnouncements { get; set; }
        public Guid AnnouncedToUserId { get; set; }
        public string AnnouncedToUser { get; set; }
        public string AnnouncedToUserImage { get; set; }
        public DateTime? ReadDateTime { get; set; }
    }
}
