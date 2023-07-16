const CalculateFreelancerRateService = (sentiments) => {
    const positiveCount = sentiments.filter(sen => sen).length;
    const negativeCount = sentiments.filter(sen => !sen).length;
    const rate = (5 * positiveCount) / (positiveCount + negativeCount) || 0;
    return Math.round((rate + Number.EPSILON) * 100) / 100;
}

export default CalculateFreelancerRateService;