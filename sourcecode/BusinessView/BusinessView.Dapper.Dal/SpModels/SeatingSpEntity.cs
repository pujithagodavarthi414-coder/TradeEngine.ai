using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class SeatingSpEntity
    {
        public Guid Id { get; set; }
        public Guid EmployeeId { get; set; }
        public string SeatCode { get; set; }
        public string Description { get; set; }
        public string Comment { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public Guid CompanyId { get; set; }
    }
}
