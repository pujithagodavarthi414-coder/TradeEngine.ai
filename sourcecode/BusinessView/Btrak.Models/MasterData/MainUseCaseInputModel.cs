using System;
using System.ComponentModel.DataAnnotations;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class MainUseCaseInputModel : InputModelBase
    {
        public MainUseCaseInputModel() : base(InputTypeGuidConstants.MainUseCaseInputCommandTypeGuid)
        {
        }
        public Guid? MainUseCaseId { get; set; }
        [StringLength(50)]
        public string MainUseCaseName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("MainUseCaseId = " + MainUseCaseId);
            stringBuilder.Append(", MainUseCaseName = " + MainUseCaseName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}