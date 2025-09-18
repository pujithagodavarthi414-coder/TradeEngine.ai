using Btrak.Models.FormDataServices;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Models.TradeManagement
{
    public class StepAlertUpdateModel
    {
        public List<ParamsKeyModel> ParamsJsonModel { get; set; }
        public Guid? Id { get; set; }
    }
}
