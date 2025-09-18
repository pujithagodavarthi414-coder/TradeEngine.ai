using System;

namespace Btrak.Models
{
    public class DesignationModel
    {
        public Guid DesignationId { get; set; }
        public string Designation { get; set; }
        public Guid DepartmentId { get; set; }
    }
}
