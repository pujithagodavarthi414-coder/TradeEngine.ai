using System;
using System.Text;

namespace Btrak.Models.CompanyStructure
{
    public class MainUseCaseOutputModel
    {
        public Guid? MainUseCaseId { get; set; }
        public string MainUseCaseName { get; set; }
        public Guid? OriginalId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", MainUseCaseId   = " + MainUseCaseId);
            stringBuilder.Append(", MainUseCaseName  = " + MainUseCaseName);
            stringBuilder.Append(", OriginalId  = " + OriginalId);
            stringBuilder.Append(", TimeStamp  = " + TimeStamp);
            stringBuilder.Append(", OriginalId  = " + OriginalId);
            return stringBuilder.ToString();
        }
    }
}
