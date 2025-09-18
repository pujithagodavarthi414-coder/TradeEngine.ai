using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class ProcInputsAndOutputModel : InputModelBase
    {
        public ProcInputsAndOutputModel() : base(InputTypeGuidConstants.WidgetUpsertInputCommandTypeGuid)
        {
        }
        public Guid? CustomWidgetId { get; set; }
        public Guid? CustomStoredProcId { get; set; }
        public string ProcName { get; set; }
        public List<InputsModel> Inputs { get; set; }
        public List<OutputsModel> Outputs { get; set; }
        public List<LegendsModel> Legends { get; set; }
        public string InputsJson { get; set; } 
        public string OutputsJson { get; set; }
        public string LegendsJson { get; set; }
        public List<CustomAppChartModel> AllChartsDetails { get; set; }
        public string CustomWidgetName { get; set; }
        public bool? IsForDashBoard { get; set; }
        public Guid? WorkspaceId { get; set; }
        public Guid? DashboardId { get; set; }
        public DashboardFilterModel DashboardFilters { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CustomWidgetId = " + CustomWidgetId);
            stringBuilder.Append(", CustomStoredProcId = " + CustomStoredProcId);
            stringBuilder.Append(", ProcName = " + ProcName);
            stringBuilder.Append(", Inputs = " + Inputs);
            stringBuilder.Append(", Outputs = " + Outputs);
            stringBuilder.Append(", InputsJson = " + InputsJson);
            stringBuilder.Append(", OutputsJson = " + OutputsJson);
            stringBuilder.Append(", LegendsJson = " + LegendsJson);
            return stringBuilder.ToString();
        }
    }

    public class InputsModel
    {
        public string ParameterName { get; set; }
        public string DataType { get; set; }
        public object InputData { get; set; }
    }

    public class OutputsModel
    {
        public string Field { get; set; }
        public string Filter { get; set; }
    }

    public class LegendsModel
    {
        public string LegendName { get; set; }
        public string Value { get; set; }
    }
}
