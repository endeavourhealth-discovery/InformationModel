import { TestBed, inject } from '@angular/core/testing';

import { ConceptSelectorService } from './concept-selector.service';

describe('ConceptSelectorService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [ConceptSelectorService]
    });
  });

  it('should be created', inject([ConceptSelectorService], (service: ConceptSelectorService) => {
    expect(service).toBeTruthy();
  }));
});
