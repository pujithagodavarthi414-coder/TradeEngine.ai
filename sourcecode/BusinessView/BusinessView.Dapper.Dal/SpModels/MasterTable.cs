using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class MasterTable
    {
        public class MasterTableDbEntity
        {

            public Guid Id { get; set; }

            public Guid MasterTableTypeId { get; set; }

            public string MasterValue { get; set; }
        }
    }
}
