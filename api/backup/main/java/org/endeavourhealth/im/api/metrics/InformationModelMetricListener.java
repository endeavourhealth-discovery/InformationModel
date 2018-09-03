package org.endeavourhealth.im.api.metrics;

import com.codahale.metrics.MetricRegistry;
import com.codahale.metrics.servlets.MetricsServlet;


public class InformationModelMetricListener extends MetricsServlet.ContextListener {
    public static final MetricRegistry informationModelMetricRegistry = InformationModelInstrumentedFilterContextListener.REGISTRY;

    @Override
    protected MetricRegistry getMetricRegistry() {
        return informationModelMetricRegistry;
    }
}
