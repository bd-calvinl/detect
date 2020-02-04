/**
 * configuration
 *
 * Copyright (c) 2020 Synopsys, Inc.
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
package com.synopsys.integration.configuration.property.types.long

import com.synopsys.integration.configuration.parse.ValueParseException
import com.synopsys.integration.configuration.property.types.longs.LongValueParser
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.ValueSource

class LongValueParserTests {
    @ParameterizedTest
    @ValueSource(strings = ["unknown", "Nan", "", " 1", "1L", "9223372036854775808"])
    fun parseUnknownThrows(value: String) {
        Assertions.assertThrows(ValueParseException::class.java) {
            LongValueParser().parse(value)
        }
    }

    @Test
    fun parseLong() {
        fun assert(expected: Long, value: String) {
            Assertions.assertEquals(expected, LongValueParser().parse(value))
        }

        assert(-1, "-1")
        assert(1, "1")
        assert(Long.MAX_VALUE, "9223372036854775807")
        assert(Long.MIN_VALUE, "-9223372036854775808")
    }
}