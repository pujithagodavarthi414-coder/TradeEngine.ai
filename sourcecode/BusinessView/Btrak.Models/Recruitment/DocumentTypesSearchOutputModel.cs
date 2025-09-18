using System;

namespace Btrak.Models.Recruitment
{
    public class DocumentTypesSearchOutputModel
    {
     
        public Guid? DocumentTypeId { get; set; }
        public string DocumentTypeName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }

    }
}
