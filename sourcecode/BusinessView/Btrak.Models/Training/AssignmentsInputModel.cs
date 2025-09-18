using System;
using System.Collections.Generic;

namespace Btrak.Models.Training
{
    public class AssignmentsInputModel
    {
        public List<Guid> CourseIds { get; set; }
        public List<Guid> UserIds { get; set; }
        public bool Assign { get; set; }
    }
}
