using System;

namespace Btrak.Models.Training
{
    public class TrainingAssignment
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public Guid? TrainingCourseId { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? StatusId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? StatusGivenDate { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? ValidityEndDate { get; set; }
        public bool? IsActive { get; set; }
    }
}
