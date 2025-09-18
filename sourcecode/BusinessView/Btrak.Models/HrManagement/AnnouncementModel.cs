using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.HrManagement
{
    public class AnnouncementModel
    {
        public Guid? AnnouncementId { get; set; }
        public string Announcement { get; set; }
        public string AnnouncedTo { get; set; }
        public int AnnouncementLevel { get; set; }
        public bool IsArchived { get; set; }

        public bool IsRead { get; set; }
        public string AnnouncedBy { get; set; }
        public string AnnouncedByRole { get; set; }
        public string AnnouncedByUserImage { get; set; }
        public Guid? AnnouncedById { get; set; }
        public Guid? EmployeeId { get; set; }
        public DateTime AnnouncedOn { get; set; }
        public int TotalAnnouncements { get; set; }
        public Guid UserId { get; set; }
        public DateTime? ReadDateTime { get; set; }
        public DateTime? AnnouncementDate { get; set; }
    }
}
