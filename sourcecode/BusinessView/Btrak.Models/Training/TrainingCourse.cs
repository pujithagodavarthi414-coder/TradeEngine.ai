using System;
using System.Text;

namespace Btrak.Models.Training
{
    public class TrainingCourse
    {
        public Guid Id { get; set; }
        public string CourseName { get; set; }
        public string CourseDescription { get; set; }
        public int ValidityInMonths { get; set; }
        public Guid CompanyId { get; set; }
        public bool IsArchived { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public int TotalCount { get; set; }
    }
}
