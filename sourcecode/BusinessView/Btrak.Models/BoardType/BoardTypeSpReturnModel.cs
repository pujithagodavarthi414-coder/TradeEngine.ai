using System;

namespace Btrak.Models.BoardType
{
    public class BoardTypeSpReturnModel
    {
        public Guid? BoardTypeId { get; set; }
        public string BoardTypeName { get; set; }

        public Guid? BoardTypeUiId { get; set; }
        public string BoardTypeUiName { get; set; }

        public Guid? WorkFlowId { get; set; }
        public string WorkFlowName { get; set; }

        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public DateTimeOffset CreatedDateTime { get; set; }
    }
}
