/**
 * synopsys-detect
 *
 * Copyright (c) 2021 Synopsys, Inc.
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package com.synopsys.integration.detect.lifecycle.run.operation.blackduck;

import org.apache.commons.lang3.StringUtils;

import com.synopsys.integration.detect.configuration.DetectUserFriendlyException;
import com.synopsys.integration.detect.lifecycle.run.RunOptions;
import com.synopsys.integration.detect.lifecycle.run.operation.Operation;
import com.synopsys.integration.detect.lifecycle.run.operation.OperationResult;
import com.synopsys.integration.detect.workflow.bdio.AggregateMode;
import com.synopsys.integration.detect.workflow.bdio.AggregateOptions;
import com.synopsys.integration.exception.IntegrationException;

public class AggregateOptionsOperation extends Operation<Boolean, AggregateOptions> {
    private final RunOptions runOptions;

    public AggregateOptionsOperation(RunOptions runOptions) {
        this.runOptions = runOptions;
    }

    @Override
    protected boolean shouldExecute() {
        return true;
    }

    @Override
    public String getOperationName() {
        return "Aggregate Options Creation";
    }

    @Override
    protected OperationResult<AggregateOptions> executeOperation(Boolean input) throws DetectUserFriendlyException, IntegrationException {
        String aggregateName = runOptions.getAggregateName().orElse(null);
        AggregateMode aggregateMode = runOptions.getAggregateMode();
        AggregateOptions aggregateOptions;
        if (StringUtils.isNotBlank(aggregateName)) {
            if (input) {
                aggregateOptions = AggregateOptions.aggregateButSkipEmpty(aggregateName, aggregateMode);
            } else {
                aggregateOptions = AggregateOptions.aggregateAndAlwaysUpload(aggregateName, aggregateMode);
            }
        } else {
            aggregateOptions = AggregateOptions.doNotAggregate();
        }

        return OperationResult.success(aggregateOptions);
    }
}
