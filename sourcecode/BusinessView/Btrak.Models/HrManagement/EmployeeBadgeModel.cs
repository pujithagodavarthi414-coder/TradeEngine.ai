using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.HrManagement
{
    public class EmployeeBadgeModel
    {
        public Guid? Id { get; set; }
        public List<Guid?> AssignedTo { get; set; }
        public string AssignedToXml { get; set; }
        public string BadgeDescription { get; set; }
        public bool IsForOverView { get; set; }
        public string AssignedToUser { get; set; }
        public Guid? AssignedById { get; set; }
        public Guid? UserId { get; set; }
        public string AssignedBy { get; set; }
        public string AssignedByProfileImage { get; set; }
        public bool IsArchived { get; set; }

        public Guid? BadgeId { get; set; }
        public string ImageUrl { get; set; }
        public string BadgeName { get; set; }
        public int BadgeCount { get; set; }
        public string BadgeDetailsXml { get; set; }
        public List<BadgeDetailsModel> BadgeDetails { get; set; }
    }

    public class BadgeDetailsModel
    {
        public Guid? AssignedById { get; set; }
        public string AssignedBy { get; set; }
        public string BadgeDescription { get; set; }
    }
}
