using System;

namespace Btrak.Models.Training
{
    public class AssignmentStatus
    {
        public Guid Id { get; set; }
        public string StatusName { get; set; }
        public string StatusDescription { get; set; }
        public string StatusColor { get; set; }
        public Guid? CompanyId { get; set; }
        public bool IsSelectable { get; set; }
        public string Icon { get; set; }
        public bool AddsValidity { get; set; }
        public bool IsActive { get; set; }
    }
}
