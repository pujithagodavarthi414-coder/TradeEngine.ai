using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class EmergencyAndDependentContactsSpEntity
    {
        public Guid Id { get; set; }
        public Guid EmployeeId { get; set; }
        public Guid RelationshipId { get; set; }
        public string Name { get; set; }
        public string SpecifiedRelation { get; set; }
        public DateTime DateOfBirth { get; set; }
        public string HomeTelephone { get; set; }
        public string MobileNo { get; set; }
        public string WorkTelephone { get; set; }
        public bool IsEmergencyContact { get; set; }
        public bool IsDependentContact { get; set; }
        public string MasterValue { get; set; }
    }
}
