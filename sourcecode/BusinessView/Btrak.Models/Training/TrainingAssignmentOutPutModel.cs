using System;
using System.Collections.Generic;

namespace Btrak.Models.Training
{
    public class TrainingAssignmentOutPutModel
    {
        public Guid UserId { get; set; }
        public string UserFullName { get; set; }
        public string UserProfileImage { get; set; }
        public string AssignmentsJson { get; set; }
        public int TotalCount { get; set; }

        public List<Assignment> Assignments 
        { 
            get 
            {
                if (!string.IsNullOrEmpty(AssignmentsJson))
                {
                    var json = AssignmentsJson;
                    AssignmentsJson = string.Empty;
                    return Newtonsoft.Json.JsonConvert.DeserializeObject<List<Assignment>>(json);
                }
                else
                {
                    return new List<Assignment>();
                }
            }
            set 
            {
                Assignments = value;
            }    
        }
    }

    public class Assignment
    {
        public Guid? AssignmentId { get; set; }
        public Guid? TrainingCourseId { get; set; }
        public string CourseName { get; set; }
        public string StatusName { get; set; }
        public DateTime? ValidityEndDate { get; set; }
        public int? ValidityInMonths { get; set; }
        public Guid? StatusId { get; set; }
        public string StatusColor { get; set; }
        public DateTime? StatusGivenDate { get; set; }
        public string StatusIcon { get; set; }
        public bool AddsValidity { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public bool IsDefaultStatus { get; set; }
    }
}
