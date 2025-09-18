using System;

namespace Btrak.Models.MasterData
{
    public class EncashmentTypeSearchOutputModel
    {
        public Guid? EncashmentTypeId { get; set; }
        public string EncashmentType { get; set; }
        public Guid? CompanyId { get; set; }
        public int? TotalCount { get; set; }

    }
}
