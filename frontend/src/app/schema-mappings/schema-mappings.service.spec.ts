import { TestBed, inject } from '@angular/core/testing';

import { SchemaMappingsService } from './schema-mappings.service';
import {HttpModule} from '@angular/http';

describe('SchemaMappingsService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [
        HttpModule
      ],
      providers: [SchemaMappingsService]
    });
  });

  it('should be created', inject([SchemaMappingsService], (service: SchemaMappingsService) => {
    expect(service).toBeTruthy();
  }));
});
