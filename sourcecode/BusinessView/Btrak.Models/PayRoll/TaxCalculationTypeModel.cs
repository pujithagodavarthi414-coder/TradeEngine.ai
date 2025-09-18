using System;

namespace Btrak.Models.PayRoll
{
    public class TaxCalculationTypeModel
    {
       public Guid? TaxCalculationTypeId { get; set; }
       public string TaxCalculationTypeName { get; set; }
       public Guid? CountryId { get; set; }
       public Guid? EmployeeId { get; set; }
    }
}
