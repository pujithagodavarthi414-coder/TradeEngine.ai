using System;

namespace Btrak.Models.HrDashboard
{
    public class ReminderModel
    {
        public Guid? ReminderId { get; set; }
        public DateTime RemindOn { get; set; }
        public Guid? OfUser { get; set; }
        public int NotificationType { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public Guid? ReferenceId { get; set; }
        public string AdditionalInfo { get; set; }
        public string Status { get; set; }
        public bool IsArchived { get; set; }
    }

    public class ReminderDetailsModel
    {
        public Guid? ReminderId { get; set; }
        public Guid? OfUser { get; set; }
        public string OfUserName { get; set; }
        public int NotificationType { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public Guid? ReferenceId { get; set; }
        public string AdditionalInfo { get; set; }
        public string Status { get; set; }
        public bool IsArchived { get; set; }

        public Guid? CompanyId { get; set; }
        public string SiteAddress { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? NotifiedBy { get; set; }
        public string CreatedByUserName { get; set; }
        public string CreatedByEmail { get; set; }
    }
}
