import { TestBed, inject } from '@angular/core/testing';

import { SchemaMappingsService } from './schema-mappings.service';

describe('SchemaMappingsService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [SchemaMappingsService]
    });
  });

  it('should be created', inject([SchemaMappingsService], (service: SchemaMappingsService) => {
    expect(service).toBeTruthy();
  }));
});
