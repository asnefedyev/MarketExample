namespace MarketExample.Models.Common
{
    public class StandartResponseMessage<T>
    {
        public string Code { get; set; }
        public string Message { get; set; }
        public string? AdditionErrCode { get; set; }
        public T Value { get; set; }
        public int Count { get; set; }
    }
}